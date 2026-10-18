import { spawn } from 'node:child_process';
import { createInterface } from 'node:readline';
import { fileURLToPath, pathToFileURL } from 'node:url';
import { mkdir, writeFile } from 'node:fs/promises';
import { join } from 'node:path';

const root = fileURLToPath(new URL('../', import.meta.url));
const child = spawn('D:/software/flutter/bin/cache/dart-sdk/bin/dart.exe', ['mcp-server', '--flutter-sdk', 'D:/software/flutter'], {
  cwd: root,
  env: { ...process.env, PUB_CACHE: 'D:/software/pub-cache' },
  windowsHide: true,
});
let id = 0;
const pending = new Map();
const send = (message) => child.stdin.write(`${JSON.stringify({ jsonrpc: '2.0', ...message })}\n`);
createInterface({ input: child.stdout }).on('line', (line) => {
  let message;
  try { message = JSON.parse(line); } catch { return; }
  if (message.method === 'roots/list') {
    send({ id: message.id, result: { roots: [{ uri: pathToFileURL(root).href, name: 'Diary Flutter Lab' }] } });
  } else if (pending.has(message.id)) {
    pending.get(message.id)(message);
    pending.delete(message.id);
  }
});
child.stderr.on('data', (data) => process.stderr.write(data));
function request(method, params) {
  return new Promise((resolve, reject) => {
    const requestId = ++id;
    const timer = setTimeout(() => { pending.delete(requestId); reject(new Error(`Timeout: ${method}`)); }, 120000);
    pending.set(requestId, (response) => { clearTimeout(timer); response.error ? reject(new Error(JSON.stringify(response.error))) : resolve(response.result); });
    send({ id: requestId, method, params });
  });
}
try {
  console.log(JSON.stringify(await request('initialize', { protocolVersion: '2024-11-05', capabilities: { roots: { listChanged: true } }, clientInfo: { name: 'diary-toolchain-smoke', version: '1.0' } })));
  send({ method: 'notifications/initialized' });
  await request('tools/call', { name: 'roots', arguments: { command: 'add', uris: [pathToFileURL(root).href] } });
  const { tools } = await request('tools/list', {});
  if (process.argv[2] === 'runtime') {
    const call = async (name, args) => {
      const result = await request('tools/call', { name, arguments: args });
      if (name === 'widget_inspector' && !result.isError) {
        const tree = JSON.parse(result.content.find((item) => item.type === 'text').text);
        const nodes = [];
        const interesting = new Set(['RootWidget','DiaryLabApp','DiaryLab','MyApp','ShadInput','ShadButton','ShadCalendar','ShadSwitch','ShadCheckbox','FloatingActionButton','EditableText']);
        const visit = (node) => {
          if (node.textPreview || interesting.has(node.widgetRuntimeType)) nodes.push({type:node.widgetRuntimeType, text:node.textPreview, description:node.description});
          for (const child of node.children || []) visit(child);
        };
        visit(tree);
        console.log(name, JSON.stringify(nodes));
      } else {
        console.log(name, JSON.stringify({...result, content:result.content?.filter((item) => item.type !== 'image')}).slice(0,4000));
      }
      for (const item of result.content || []) {
        if (item.type === 'image') {
          await mkdir(join(root, 'artifacts'), {recursive:true});
          const file = join(root, 'artifacts', process.env.DIARY_SCREENSHOT_NAME || 'native-driver.png');
          await writeFile(file, Buffer.from(item.data, 'base64'));
          console.log('Screenshot saved:', file);
        }
      }
      if (result.isError) throw new Error(`${name} failed`);
      return result;
    };
    await call('dtd', { command: 'connect', uri: process.argv[3] });
    await call('dtd', { command: 'listConnectedApps' });
    await call('widget_inspector', { command: 'get_widget_tree', summaryOnly: true });
    for (const arguments_ of JSON.parse(process.argv[4] || '[]')) {
      await call('flutter_driver_command', arguments_);
    }
    await call('hot_reload', {});
    await call('get_runtime_errors', {});
  } else if (process.argv[2]) {
    const name = process.argv[2];
    if (!tools.some((tool) => tool.name === name)) throw new Error(`Unknown tool: ${name}`);
    console.log(JSON.stringify(await request('tools/call', { name, arguments: JSON.parse(process.argv[3] || '{}') })));
  } else {
    console.log(JSON.stringify(tools.map(({ name }) => name)));
    const inspected = ['flutter_driver_command'];
    console.log(JSON.stringify(tools.filter(({ name }) => inspected.includes(name)).map(({ name, inputSchema }) => ({ name, inputSchema })), null, 2));
  }
} finally {
  child.stdin.end();
  child.kill();
}
