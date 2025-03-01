---
title: Mandatory-to-Implement Algorithms for Authors and Recipients of Software Update for the Internet of Things manifests
abbrev: MTI SUIT Algorithms
docname: draft-ietf-suit-mti
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
      organization: Openchip & Software Technologies, S.L.
      email: akira.tsukamoto@gmail.com

normative:
  RFC8152:
  RFC8778:
  RFC9052: cose
  RFC9459: ctrcbc
  I-D.ietf-suit-manifest:

informative:
  I-D.ietf-suit-firmware-encryption:
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
* Two "Current" Constrained Asymmetric MTI profiles
* Two "Current" AEAD Asymmetric MTI profiles
* One "Future" Constrained Asymmetric MTI profile

At least one MTI algorithm in each category MUST be FIPS qualified.

Because SUIT presents an asymmetric communication profile, with powerful/complex manifest authors and constrained manifest recipients, the requirements for Recipients and Authors are different.

Recipients MAY choose which MTI profile they wish to implement. It is RECOMMENDED that they implement the "Future" Asymmetric MTI profile. Recipients MAY implement any number of other profiles. Recipients MAY choose not to implement an encryption algorithm if encrypted payloads will never be used.

Authors MUST implement all MTI profiles. Authors MAY implement any number of other profiles.

AEAD is preferred over un-authenticated encryption. Where possible an AEAD profile SHOULD be selected. Certain constrained IoT applications require streaming decryption, which necessitates a non-AEAD ecryption algorithm. If the application is not a constrained device, the two AEAD profiles are RECOMMENDED.

Other use-cases of SUIT MAY define their own MTI algorithms.

# Algorithms

The algorithms that form a part of the profiles defined in this document are grouped into:

* Digest Algorithms
* Authentication Algorithms
* Key Exchange Algorithms (OPTIONAL)
* Encryption Algorithms (OPTIONAL)

# Profiles

Recognized profiles are defined below.

## Symmetric MTI profile: suit-sha256-hmac-a128kw-a128ctr {#suit-sha256-hmac-a128kw-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | HMAC-256 | 5 |
| Key Exchange | A128KW Key Wrap | -3 |
| Encryption | A128CTR | -65534 |

## Current Constrained Asymmetric MTI Profile 1: suit-sha256-es256-ecdh-a128ctr {#suit-sha256-es256-ecdh-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | ES256 | -7 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128CTR | -65534 |

## Current Constrained Asymmetric MTI Profile 2: suit-sha256-eddsa-ecdh-a128ctr {#suit-sha256-eddsa-ecdh-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | EDDSA | -8 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128CTR | -65534 |

## Current AEAD Asymmetric MTI Profile 1: suit-sha256-es256-ecdh-a128gcm {#suit-sha256-es256-ecdh-a128gcm}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | ES256 | -7 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128GCM | 1 |

## Current AEAD Asymmetric MTI Profile 2: suit-sha256-eddsa-ecdh-chacha-poly {#suit-sha256-eddsa-ecdh-chacha-poly}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | EDDSA | -8 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | ChaCha20/Poly1305 | 24 |


## Future Constrained Asymmetric MTI Profile 1: suit-sha256-hsslms-a256kw-a256ctr {#suit-sha256-hsslms-a256kw-a256ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | HSS-LMS | -46 |
| Key Exchange | A256KW | -5 |
| Encryption | A256CTR | -65532 |

This draft does not specify a particular set of HSS-LMS parameters. Deep trees are RECOMMENDED due to key lifetimes in IoT devices.

# Reporting Profiles

When using reverse-direction communication, particularly data structures that are designed for reporting of update capabilities, status, progress, or success, the same profile as the is used on the SUIT manifest SHOULD be used. There are cases where this is not possible, such as suit-sha256-hsslms-a256kw-a256ctr. In this case, the closest equivalent profile SHOULD be used, for example suit-sha256-es256-ecdh-a128ctr.

# Security Considerations

For the avoidance of doubt, there are scenarios where payload or manifest encryption are not required. In these scenarios, the encryption element of the selected profile is simply not used.

AES-CTR mode is specified, see {{-ctrcbc}}. All of the AES-CTR security considerations in {{-ctrcbc}} apply. A non-AEAD encryption mode is specified in this draft due to the following mitigating circumstances:

* Streaming decryption must be supported. Therefore, there is no difference between AEAD and plaintext hash verification.
* Out-of-order decryption must be supported. Therefore, we must use a stream cipher that supports random access.
* There are no chosen plaintext attacks: the plaintext is authenticated prior to encryption.
* Content Encryption Keys must be used to encrypt only once. See {{I-D.ietf-suit-firmware-encryption}}.

As a result of these mitigating circumstances, AES-CTR is the most appropriate cipher for typical software/firmware delivery scenarios.

# IANA Considerations

IANA is requested to create a page for COSE Algorithm Profiles within
the category for Software Update for the Internet of Things (SUIT) 

IANA is also requested to create a registry for COSE Alforithm Profiles
within this page. The initial content of the registry is:

| Profile | Status | Digest | Auth | Key Exchange | Encryption | Descriptor Array | Reference
|====|
| suit-sha256-hmac-a128kw-a128ctr    | MANDATORY | -16 | 5   | -3  | -65534 | \[-16,   5,  -3, -65534\] | {{suit-sha256-hmac-a128kw-a128ctr}}
| suit-sha256-es256-ecdh-a128ctr     | MANDATORY | -16 | -7  | -29 | -65534 | \[-16,  -7, -29, -65534\] | {{suit-sha256-es256-ecdh-a128ctr}}
| suit-sha256-eddsa-ecdh-a128ctr     | MANDATORY | -16 | -8  | -29 | -65534 | \[-16,  -8, -29, -65534\] | {{suit-sha256-eddsa-ecdh-a128ctr}}
| suit-sha256-es256-ecdh-a128gcm     | MANDATORY | -16 | -7  | -29 | 1      | \[-16,  -7, -29,      1\] | {{suit-sha256-es256-ecdh-a128gcm}}
| suit-sha256-eddsa-ecdh-chacha-poly | MANDATORY | -16 | -8  | -29 | 24     | \[-16,  -8, -29,     24\] | {{suit-sha256-eddsa-ecdh-chacha-poly}}
| suit-sha256-hsslms-a256kw-a256ctr  | MANDATORY | -16 | -46 | -5  | -65532 | \[-16, -46,  -5, -65532\] | {{suit-sha256-hsslms-a256kw-a256ctr}}

New entries to this registry require standards action.

--- back

# A. Full CDDL {#full-cddl}

The following CDDL creates a subset of COSE for use with SUIT. Both tagged and untagged messages are defined. SUIT only uses tagged COSE messages, but untagged messages are also defined for use in protocols that share a ciphersuite with SUIT.

To be valid, the following CDDL MUST have the COSE CDDL appended to it. The COSE CDDL can be obtained by following the directions in {{-cose, Section 1.4}}.

~~~ CDDL
{::include draft-ietf-suit-mti.cddl}
~~~
