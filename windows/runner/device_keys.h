// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only
#ifndef RUNNER_DEVICE_KEYS_H_
#define RUNNER_DEVICE_KEYS_H_

#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>
#include <memory>

std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
RegisterDeviceKeys(flutter::BinaryMessenger* messenger);
std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
RegisterNearbySettings(flutter::BinaryMessenger* messenger);

#endif
