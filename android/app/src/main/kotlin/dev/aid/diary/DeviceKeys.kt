// Copyright (C) 2026 Demizo and contributors
// SPDX-License-Identifier: GPL-3.0-only

package dev.aid.diary

import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyInfo
import android.security.keystore.KeyProperties
import android.util.Base64
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import java.security.KeyFactory
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.Signature
import java.security.spec.ECGenParameterSpec

/** Device authentication keys never leave the Android Keystore. */
class DeviceKeys(messenger: BinaryMessenger, private val namespace: String) {
  init {
    MethodChannel(messenger, "aid.device_keys").setMethodCallHandler { call, result ->
      try {
        val alias = call.argument<String>("alias")
        require(alias != null && Regex("^[A-Za-z0-9_-]{1,128}$").matches(alias))
        val name = "$namespace.$alias"
        val store = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        when (call.method) {
          "ensure" -> {
            if (!store.containsAlias(name)) {
              KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_EC, "AndroidKeyStore").apply {
                initialize(KeyGenParameterSpec.Builder(name, KeyProperties.PURPOSE_SIGN)
                    .setAlgorithmParameterSpec(ECGenParameterSpec("secp256r1"))
                    .setDigests(KeyProperties.DIGEST_SHA256).build())
              }.generateKeyPair()
            }
            val key = store.getKey(name, null) as PrivateKey
            val info = KeyFactory.getInstance(key.algorithm, "AndroidKeyStore")
                .getKeySpec(key, KeyInfo::class.java)
            @Suppress("DEPRECATION")
            val hardware = info.isInsideSecureHardware
            result.success(mapOf(
                "publicKeySpki" to Base64.encodeToString(store.getCertificate(name).publicKey.encoded, Base64.NO_WRAP),
                "hardwareBacked" to hardware, "provider" to "AndroidKeyStore"))
          }
          "sign" -> {
            val encoded = call.argument<String>("message") ?: throw IllegalArgumentException()
            require(encoded.length <= 87384)
            val message = Base64.decode(encoded, Base64.DEFAULT)
            require(message.size <= 65536)
            val key = store.getKey(name, null) as? PrivateKey
                ?: throw IllegalStateException("missing_key")
            val signature = Signature.getInstance("SHA256withECDSA").apply {
              initSign(key)
              update(message)
            }.sign()
            result.success(mapOf("signature" to Base64.encodeToString(signature, Base64.NO_WRAP)))
          }
          "delete" -> {
            store.deleteEntry(name)
            result.success(null)
          }
          else -> result.notImplemented()
        }
      } catch (_: IllegalArgumentException) {
        result.error("bad_args", "Invalid device key arguments", null)
      } catch (_: Exception) {
        result.error("key_operation_failed", "Device key operation failed", null)
      }
    }
  }
}
