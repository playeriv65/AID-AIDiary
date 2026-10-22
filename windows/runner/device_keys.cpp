// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

#include "device_keys.h"
#include <windows.h>
#include <bcrypt.h>
#include <ncrypt.h>
#include <wincrypt.h>
#include <shellapi.h>
#include <flutter/standard_method_codec.h>
#include <algorithm>
#include <cstring>
#include <stdexcept>
#include <string>
#include <vector>

namespace {
using Value = flutter::EncodableValue;
using Map = flutter::EncodableMap;
using Bytes = std::vector<BYTE>;
struct KeyHandle {
  NCRYPT_HANDLE value = 0;
  ~KeyHandle() { if (value) NCryptFreeObject(value); }
};
void Check(SECURITY_STATUS status) {
  if (status != ERROR_SUCCESS) throw std::runtime_error("key_operation_failed");
}
std::string StringArg(const Map& args, const char* name) {
  auto it = args.find(Value(name));
  if (it == args.end() || !std::holds_alternative<std::string>(it->second))
    throw std::invalid_argument("bad_args");
  return std::get<std::string>(it->second);
}
Bytes Hash(const Bytes& bytes) {
  Bytes digest(32);
  DWORD count = static_cast<DWORD>(digest.size());
  if (!CryptHashCertificate2(BCRYPT_SHA256_ALGORITHM, 0, nullptr,
      bytes.data(), static_cast<DWORD>(bytes.size()), digest.data(), &count))
    throw std::runtime_error("hash_failed");
  return digest;
}
std::wstring KeyName(const std::string& alias) {
  if (alias.empty() || alias.size() > 128 || !std::all_of(alias.begin(), alias.end(), [](char c) {
      return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') ||
          (c >= '0' && c <= '9') || c == '_' || c == '-';
    })) throw std::invalid_argument("bad_args");
  std::wstring prefix = L"AID.Diary.device.default.";
  DWORD size = GetEnvironmentVariableW(L"AID_DATA_DIR", nullptr, 0);
  if (size > 0) {
    std::wstring path(size, L'\0');
    GetEnvironmentVariableW(L"AID_DATA_DIR", path.data(), size);
    Bytes bytes(reinterpret_cast<const BYTE*>(path.data()),
                reinterpret_cast<const BYTE*>(path.data()) + (size - 1) * sizeof(wchar_t));
    const auto digest = Hash(bytes);
    prefix = L"AID.Diary.device.scratch.";
    constexpr wchar_t hex[] = L"0123456789abcdef";
    for (const auto byte : digest) { prefix += hex[byte >> 4]; prefix += hex[byte & 15]; }
    prefix += L".";
  }
  return prefix + std::wstring(alias.begin(), alias.end());
}
std::string Encode(const Bytes& bytes) {
  DWORD size = 0;
  const DWORD flags = CRYPT_STRING_BASE64 | CRYPT_STRING_NOCRLF;
  if (!CryptBinaryToStringA(bytes.data(), static_cast<DWORD>(bytes.size()), flags, nullptr, &size))
    throw std::runtime_error("encoding_failed");
  std::string result(size, '\0');
  if (!CryptBinaryToStringA(bytes.data(), static_cast<DWORD>(bytes.size()), flags, result.data(), &size))
    throw std::runtime_error("encoding_failed");
  result.resize(size);
  while (!result.empty() && result.back() == '\0') result.pop_back();
  return result;
}
Bytes Decode(const std::string& encoded) {
  if (encoded.size() > 87384) throw std::invalid_argument("bad_args");
  if (encoded.empty()) return {};
  DWORD size = 0;
  if (!CryptStringToBinaryA(encoded.data(), static_cast<DWORD>(encoded.size()), CRYPT_STRING_BASE64,
      nullptr, &size, nullptr, nullptr) || size > 65536) throw std::invalid_argument("bad_args");
  Bytes result(size);
  if (!CryptStringToBinaryA(encoded.data(), static_cast<DWORD>(encoded.size()), CRYPT_STRING_BASE64,
      result.data(), &size, nullptr, nullptr)) throw std::invalid_argument("bad_args");
  return result;
}
void Integer(Bytes& der, const BYTE* value) {
  size_t skip = 0;
  while (skip < 31 && value[skip] == 0) ++skip;
  const bool pad = (value[skip] & 0x80) != 0;
  der.push_back(2);
  der.push_back(static_cast<BYTE>(32 - skip + (pad ? 1 : 0)));
  if (pad) der.push_back(0);
  der.insert(der.end(), value + skip, value + 32);
}
}

std::unique_ptr<flutter::MethodChannel<Value>> RegisterDeviceKeys(flutter::BinaryMessenger* messenger) {
  auto channel = std::make_unique<flutter::MethodChannel<Value>>(
      messenger, "aid.device_keys", &flutter::StandardMethodCodec::GetInstance());
  channel->SetMethodCallHandler([](const auto& call, auto result) {
    try {
      const auto* args = std::get_if<Map>(call.arguments());
      if (!args) throw std::invalid_argument("bad_args");
      const auto name = KeyName(StringArg(*args, "alias"));
      KeyHandle provider, key;
      Check(NCryptOpenStorageProvider(&provider.value, MS_KEY_STORAGE_PROVIDER, 0));
      auto status = NCryptOpenKey(provider.value, &key.value, name.c_str(), 0, NCRYPT_SILENT_FLAG);
      if (call.method_name() == "ensure") {
        if (status == NTE_BAD_KEYSET) {
          Check(NCryptCreatePersistedKey(provider.value, &key.value, NCRYPT_ECDSA_P256_ALGORITHM,
              name.c_str(), 0, 0));
          DWORD noExport = 0;
          Check(NCryptSetProperty(key.value, NCRYPT_EXPORT_POLICY_PROPERTY,
              reinterpret_cast<PBYTE>(&noExport), sizeof(noExport), 0));
          Check(NCryptFinalizeKey(key.value, NCRYPT_SILENT_FLAG));
        } else { Check(status); }
        DWORD exportPolicy = 0, propertySize = 0;
        Check(NCryptGetProperty(key.value, NCRYPT_EXPORT_POLICY_PROPERTY,
            reinterpret_cast<PBYTE>(&exportPolicy), sizeof(exportPolicy), &propertySize, 0));
        if (exportPolicy != 0) throw std::runtime_error("exportable_key");
        DWORD count = 0;
        Check(NCryptExportKey(key.value, 0, BCRYPT_ECCPUBLIC_BLOB, nullptr, nullptr, 0, &count, 0));
        Bytes blob(count);
        Check(NCryptExportKey(key.value, 0, BCRYPT_ECCPUBLIC_BLOB, nullptr, blob.data(), count, &count, 0));
        if (count != sizeof(BCRYPT_ECCKEY_BLOB) + 64) throw std::runtime_error("unexpected_key");
        BCRYPT_ECCKEY_BLOB header{};
        std::memcpy(&header, blob.data(), sizeof(header));
        if (header.dwMagic != BCRYPT_ECDSA_PUBLIC_P256_MAGIC || header.cbKey != 32)
          throw std::runtime_error("unexpected_key");
        Bytes spki = {0x30,0x59,0x30,0x13,0x06,0x07,0x2a,0x86,0x48,0xce,0x3d,0x02,0x01,
          0x06,0x08,0x2a,0x86,0x48,0xce,0x3d,0x03,0x01,0x07,0x03,0x42,0x00,0x04};
        spki.insert(spki.end(), blob.begin() + sizeof(BCRYPT_ECCKEY_BLOB), blob.end());
        result->Success(Value(Map{{Value("publicKeySpki"), Value(Encode(spki))},
            {Value("hardwareBacked"), Value(false)}, {Value("provider"), Value("Windows CNG")}}));
      } else if (call.method_name() == "sign") {
        Check(status);
        const auto digest = Hash(Decode(StringArg(*args, "message")));
        DWORD count = 0;
        Check(NCryptSignHash(key.value, nullptr, const_cast<PBYTE>(digest.data()),
            static_cast<DWORD>(digest.size()), nullptr, 0, &count, NCRYPT_SILENT_FLAG));
        Bytes signature(count);
        Check(NCryptSignHash(key.value, nullptr, const_cast<PBYTE>(digest.data()),
            static_cast<DWORD>(digest.size()), signature.data(), count, &count, NCRYPT_SILENT_FLAG));
        if (count != 64) throw std::runtime_error("unexpected_signature");
        Bytes der = {0x30, 0};
        Integer(der, signature.data());
        Integer(der, signature.data() + 32);
        der[1] = static_cast<BYTE>(der.size() - 2);
        result->Success(Value(Map{{Value("signature"), Value(Encode(der))}}));
      } else if (call.method_name() == "delete") {
        if (status != NTE_BAD_KEYSET) {
          Check(status);
          Check(NCryptDeleteKey(key.value, NCRYPT_SILENT_FLAG));
          key.value = 0;
        }
        result->Success();
      } else { result->NotImplemented(); }
    } catch (const std::invalid_argument&) {
      result->Error("bad_args", "Invalid device key arguments");
    } catch (const std::exception&) {
      result->Error("key_operation_failed", "Device key operation failed");
    }
  });
  return channel;
}

std::unique_ptr<flutter::MethodChannel<Value>> RegisterNearbySettings(flutter::BinaryMessenger* messenger) {
  auto channel = std::make_unique<flutter::MethodChannel<Value>>(
      messenger, "aid.nearby", &flutter::StandardMethodCodec::GetInstance());
  channel->SetMethodCallHandler([](const auto& call, auto result) {
    const wchar_t* uri = nullptr;
    if (call.method_name() == "openWifiSettings") uri = L"ms-settings:network-wifi";
    else if (call.method_name() == "openHotspotSettings") uri = L"ms-settings:network-mobilehotspot";
    else { result->NotImplemented(); return; }
    if (reinterpret_cast<INT_PTR>(ShellExecuteW(nullptr, L"open", uri, nullptr, nullptr, SW_SHOWNORMAL)) <= 32)
      result->Error("unavailable", "Network settings are unavailable");
    else result->Success();
  });
  return channel;
}
