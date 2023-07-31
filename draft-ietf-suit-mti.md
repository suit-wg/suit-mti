---
title: Mandatory-to-Implement Algorithms for Authors and Recipients of Software Update for the Internet of Things manifests
abbrev: MTI SUIT Algorithms
docname: draft-ietf-suit-mti-02
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
      organization: ALAXALA Networks Corp.
      email: akira.tsukamoto@alaxala.com

normative:
  RFC8152:
  RFC8778:
  RFC9052: cose
  I-D.ietf-cose-aes-ctr-and-cbc:
  I-D.ietf-suit-firmware-encryption:

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

Mandatory algorithms may change over time due to an evolving threat landscape. Algorithms are grouped into algorithm profiles to account for this. Profiles may be deprecated over time. SUIT will define five choices of MTI profile specifically for constrained node software update. These profiles are:

* One Symmetric MTI profile
* Three "Current" Asymmetric MTI profiles
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

# Profiles

Recognized profiles are defined below.

## Symmetric MTI profile: suit-sha256-hmac-a128-a128ctr {#suit-sha256-hmac-a128-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | HMAC-256 | 5 |
| Key Exchange | A128W Key Wrap | -3 |
| Encryption | A128CTR | -65534 |

## Current Asymmetric MTI Profile 1: suit-sha256-es256-ecdh-a128ctr {#suit-sha256-es256-ecdh-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | ES256 | -7 |
| Key Exchange | ECDH-ES + HKDF-256 | -25 |
| Encryption | A128CTR | -65534 |

## Current Asymmetric MTI Profile 2: suit-sha256-eddsa-ecdh-a128ctr {#suit-sha256-eddsa-ecdh-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | EDDSA | -8 |
| Key Exchange | ECDH-ES + HKDF-256 | -25 |
| Encryption | A128CTR | -65534 |

## Current Asymmetric MTI Profile 3: suit-sha256-eddsa-ecdh-chacha-poly {#suit-sha256-eddsa-ecdh-chacha-poly}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | EDDSA | -8 |
| Key Exchange | ECDH-ES + HKDF-256 | -25 |
| Encryption | ChaCha20/Poly1305 | 24 |

## Future Asymmetric MTI Profile 1: suit-sha256-hsslms-ecdh-a128ctr {#suit-sha256-hsslms-ecdh-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | HSS-LMS | -46 |
| Key Exchange | ECDH-ES + HKDF-256 | -25 |
| Encryption | A128CTR | -65534 |

# Reporting Profiles

When using reverse-direction communication, particularly data structures that are designed for reporting of update capabilities, status, progress, or success, the same profile as the is used on the SUIT manifest SHOULD be used. There are cases where this is not possible, such as suit-sha256-hsslms-ecdh-a128ctr. In this case, the closest equivalent profile SHOULD be used, for example suit-sha256-ecdsa-ecdh-a128ctr.

# Security Considerations

For the avoidance of doubt, there are scenarios where payload or manifest encryption are not required. In these scenarios, the encryption element of the selected profile is simply not used.

AES-CTR mode is specified, see {{I-D.ietf-cose-aes-ctr-and-cbc}}. All of the AES-CTR security considerations in {{I-D.ietf-cose-aes-ctr-and-cbc}} apply. A non-AEAD encryption mode is specified in this draft due to the following mitigating circumstances:

* Streaming decryption must be supported. Therefore, there is no difference between AEAD and plaintext hash verification.
* Out-of-order decryption must be supported. Therefore, we must use a stream cipher that supports random access.
* There are no chosen plaintext attacks: the plaintext is authenticated prior to encryption.
* Content Encryption Keys MUST be used to encrypt only once. See {{I-D.ietf-suit-firmware-encryption}}.

As a result of these mitigating circumstances, AES-CTR is the most appropriate cipher for typical software/firmware delivery scenarios.

# IANA Considerations

IANA is requested to create a page for COSE Algorithm Profiles within
the category for Software Update for the Internet of Things (SUIT) 

IANA is also requested to create a registry for COSE Alforithm Profiles
within this page. The initial content of the registry is:

| Profile | Status | Digest | Authentication | Key Exchange | Encryption | Descriptor Array | Reference
|====|
| suit-sha256-hmac-a128-a128ctr   | MANDATORY | -16 | 5  | -3  | -65534 | \[-16, 5, -3, -65534\]  | {{suit-sha256-hmac-a128-a128ctr}}
| suit-sha256-es256-ecdh-a128ctr  | MANDATORY | -16 | -7 | -25 | -65534  | \[-16, -7, -25, -65534\]  | {{suit-sha256-es256-ecdh-a128ctr}}
| suit-sha256-eddsa-ecdh-a128ctr  | MANDATORY | -16 | -8 | -25 | -65534  | \[-16, -8, -25, -65534\]  | {{suit-sha256-eddsa-ecdh-a128ctr}}
| suit-sha256-eddsa-ecdh-chacha-poly | MANDATORY | -16 | -8 | -25 | 24 | \[-16, -8, -25, 24\] | {{suit-sha256-eddsa-ecdh-chacha-poly}}
| suit-sha256-hsslms-ecdh-a128ctr | MANDATORY | -16 | -46 | -25 | -65534  | \[-16, -46, -25, -65534\] | {{suit-sha256-hsslms-ecdh-a128ctr}}

New entries to this registry require standards action.

-- back

# A. Full CDDL {#full-cddl}

The following CDDL creates a subset of COSE for use with SUIT. Both tagged and untagged messages are defined. SUIT only uses tagged COSE messages, but untagged messages are also defined for use in protocols that share a ciphersuite with SUIT.

To be valid, the following CDDL MUST have the COSE CDDL appended to it. The COSE CDDL can be obtained by following the directions in {{-cose, Section 1.4}}.

~~~ CDDL
{::include draft-ietf-suit-mti.cddl}
~~~
