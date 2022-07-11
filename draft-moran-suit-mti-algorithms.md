---
title: Mandatory-to-Implement Algorithms for Creators and Consumers of Software Update for the Internet of Things manifests
abbrev: MTI SUIT Algorithms
docname: draft-moran-suit-mti-00
category: std

area: Security
workgroup: SUIT
keyword: Internet-Draft

ipr: trust200902

consensus: no

stand_alone: yes
pi:
  rfcedstyle: yes
  toc: yes
  tocindent: yes
  sortrefs: yes
  symrefs: yes
  strict: yes
  comments: yes
  inline: yes
  text-list-symbols: -o*+
  docmapping: yes
  toc_levels: 4

author:
 -
      ins: B. Moran
      name: Brendan Moran
      organization: Arm Limited
      email: Brendan.Moran@arm.com

normative:
  RFC8152:
  RFC8778:

informative:
  I-D.ietf-suit-manifest:

--- abstract

This document specifies algorithm profiles for SUIT manifest parsers and authors to ensure better interoperability.

--- middle

#  Introduction

Mandatory algorithms may change over time due to an evolving threat landscape. As a result these are grouped into profiles that a device should use. 

the mandatory-to implement algorithms for SUIT are described in this draft in order to provide flexibility in the definition of algorithm profiles.

An authentication algorithm is REQUIRED for ALL SUIT manifests. Encryption algorithms MAY be provided.

# Algorithms

The algorithms that form a part of the profiles defined in this document are grouped into:

* Digest Algorithms
* Authentication Algorithms
* Key Exchange Algorithms
* Encryption Algorithms

## Digest Algorithms

* SHA-256 (-16)
* SHAKE128 (-18)
* SHA-384 (-43)
* SHA-512 (-44)
* SHAKE256 (-45)

## Authentication Algorithms

Authentication Algorithms are divided into three categories:

### Symmetric Authentication Algorithm

* HMAC-256 (5)
* HMAC-384 (6)
* HMAC-512 (7)

### Asymmetric Classical Authentication Algorithms

* ES256 (-7)
* EdDSA (-8)
* ES384 (-35)
* ES512 (-36)

### Asymmetric Post-Quantum Authentication Algorithms

* HSS-LMS (-46) {{RFC8778}}
* XMSS (TBD)
* Falcon-512 (TBD)
* SPHINCS+ (TBD)
* Crystals-Dilithium (TBD)

## Key Exchange Algorithms

Key Exchange Algorithms are divided into two three groups: Symmetric, Classical Asymmetric, and Post-Quantum Asymmetric

### Symmetric

* A128 (-3)
* A192 (-4)
* A256 (-5)

### Classical Asymmetric

* HPKE (TBD)
* ECDH-ES + HKDF-256 (-25)
* ECDH-ES + HKDF-512 (-26)
* ECDH-ES + A128KW (-29)
* ECDH-ES + A192KW (-30)
* ECDH-ES + A256KW (-31)

### Post-Quantum Asymmetric

* CRYSTALS-KYBER (TBD)

## Encryption Algorithms

* A128GCM (1)
* A192GCM (2)
* A256GCM (3)
* ChaCha20/Poly1305 (24)
* AES-MAC 128/128 (25)
* AES-MAC 256/128 (26)
* AES-CCM-16-128-128 (30)
* AES-CCM-16-128-256 (31)
* AES-CCM-64-128-128 (32)
* AES-CCM-64-128-256 (33)

# Profiles

The following profiles are defined by this draft:

* suit-sha256-es256-hpke-a128gcm
    * SHA-256
    * ES256
    * HPKE
    * AES-128-GCM
* suit-sha256-hmac-a128-ccm
    * SHA-256
    * HMAC-256
    * A128W Key Wrap
    * AES-CCM-16-128-128
* suit-sha256-eddsa-ecdh-es-chacha-poly
    * SHA-256
    * EdDSA
    * ECDH-ES + HKDF-256
    * ChaCha20 + Poly1305
* suit-sha256-hsslms-hpke-a128gcm
    * SHA-256
    * HSS-LMS
    * HPKE
    * AES-128-GCM
* suit-sha256-falcon512-hpke-a128gcm
    * SHA-256
    * HSS-LMS
    * HPKE
    * AES-128-GCM
* suit-shake256-dilithium-kyber-a128gcm
    * SHAKE256
    * Crystals-Dilithium
    * Crystal-Kyber
    * AES-128GCM

# Security Considerations

TODO

# IANA Considerations

TODO
