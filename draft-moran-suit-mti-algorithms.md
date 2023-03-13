---
title: Mandatory-to-Implement Algorithms for Authors and Recipients of Software Update for the Internet of Things manifests
abbrev: MTI SUIT Algorithms
docname: draft-ietf-suit-mti-00
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
      email: brendan.moran.ietf@gmail.com
 -
      ins: Ø. Rønningstad
      name: Øyvind Rønningstad
      organization: Nordic Semiconductor
      email: oyvind.ronningstad@gmail.com
 -
      ins: A. Tsukamoto
      name: Akira Tsukamoto
      organization:
      email: akira.tsukamoto@gmail.com

normative:
  RFC8152:
  RFC8778:

informative:
  I-D.ietf-suit-manifest:
  IANA-COSE:
    title: "CBOR Object Signing and Encryption (COSE)"
    author:
    date: 2022
    target: https://www.iana.org/assignments/cose/cose.xhtml

--- abstract

This document specifies algorithm profiles for SUIT manifest parsers and authors to ensure better interoperability. These profiles apply specifically to a constrained node software update use case.

--- middle

#  Introduction

Mandatory algorithms may change over time due to an evolving threat landscape. Algorithms are grouped into algorithm profiles to account for this. Profiles may be deprecated over time. SUIT will define four choices of MTI profile specifically for constrained node software update. These profiles are:

* One Symmetric MTI profile
* Two "Current" Asymmetric MTI profiles
* One "Future" Asymmetric MTI profile

At least one MTI algorithm in each category MUST be FIPS qualified.

Because SUIT presents an asymmetric communication profile, with powerful/complex manifest authors and constrained manifest recipients, the requirements for Recipients and Authors are different.

Recipients MAY choose which MTI profile they wish to implement. It is RECOMMENDED that they implement the "Future" Asymmetric MTI profile. Recipients MAY implement any number of other profiles.

Authors MUST implement all MTI profiles. Authors MAY implement any number of other profiles.

Other use-cases of SUIT MAY define their own MTI algorithms.

# Algorithms

The algorithms that form a part of the profiles defined in this document are grouped into:

* Digest Algorithms
* Authentication Algorithms
* Key Exchange Algorithms
* Encryption Algorithms

The COSE algorithm ID {{IANA-COSE}} for each algorithm is given in parentheses.

## Digest Algorithms

* SHA-256 (-16)

## Authentication Algorithms

Authentication Algorithms are divided into three groups: Symmetric, Asymmetric Classical, and Asymmetric Post-Quantum

### Symmetric Authentication Algorithm

* HMAC-256 (5)

### Asymmetric Classical Authentication Algorithms

* ES256 (-7)
* EdDSA (-8)

### Asymmetric Post-Quantum Authentication Algorithms

* HSS-LMS (-46) {{RFC8778}}

## Key Exchange Algorithms

Key Exchange Algorithms are divided into two groups: Symmetric, and Asymmetric Classical

### Symmetric

* A128 (-3)

### Asymmetric Classical

* COSE HPKE (TBD)
* ECDH-ES + HKDF-256 (-25)

## Encryption Algorithms

* A128GCM (1)

# Profiles

Recognized profiles are defined below.

## Symmetric MTI profile: suit-sha256-hmac-a128-ccm

This profile requires the following algorithms:

* SHA-256
* HMAC-256
* A128W Key Wrap
* AES-CCM-16-128-128

## Current Asymmetric MTI Profile 1: suit-sha256-es256-ecdh-a128gcm

This profile requires the following algorithms:

* SHA-256
* ES256
* ECDH
* AES-128-GCM

## Current Asymmetric MTI Profile 2: suit-sha256-eddsa-ecdh-a128gcm

This profile requires the following algorithms:

* SHA-256
* EDDSA
* ECDH
* AES-128-GCM

## Future Asymmetric MTI Profile: suit-sha256-hsslms-hpke-a128gcm

This profile requires the following algorithms:

* SHA-256
* HSS-LMS
* HPKE
* AES-128-GCM

## Other Profiles:

Optional classical and PQC profiles are defined below.

* suit-sha256-eddsa-ecdh-es-chacha-poly
    * SHA-256
    * EdDSA
    * ECDH-ES + HKDF-256
    * ChaCha20 + Poly1305
* suit-sha256-falcon512-hpke-a128gcm
    * SHA-256
    * Falcon-512
    * HPKE
    * AES-128-GCM
* suit-shake256-dilithium-kyber-a128gcm
    * SHAKE256
    * Crystals-Dilithium
    * Crystal-Kyber
    * AES-128GCM

# Security Considerations

For the avoidance of doubt, there are scenarios where payload or manifest encryption are not required. In these scenarios, the encryption element of the selected profile is simply not used.

# IANA Considerations

TODO

-- back

# A. Full CDDL {#full-cddl}

The following CDDL creates a subset of COSE for use with SUIT. Both tagged and untagged messages are defined. SUIT only uses tagged COSE messages, but untagged messages are also defined for use in protocols that share a ciphersuite with SUIT.

To be valid, the following CDDL MUST have the COSE CDDL appended to it. The COSE CDDL can be obtained by following the directions in {{-cose, Section 1.4}}.

~~~ CDDL
{::include draft-ietf-suit-mti-algorithms.cddl}
~~~
