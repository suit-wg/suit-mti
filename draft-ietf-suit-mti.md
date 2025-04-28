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
  I-D.ietf-jose-fully-specified-algorithms:

informative:
  I-D.ietf-suit-firmware-encryption:
  IANA-COSE:
    title: "CBOR Object Signing and Encryption (COSE)"
    author:
    date: 2022
    target: https://www.iana.org/assignments/cose/cose.xhtml
  RFC8890:

--- abstract

This document specifies cryptographic algorithm profiles to be used with the SUIT manifest (see draft-ietf-suit-manifest).  These are the mandatory-to-implement algorithms to ensure interoperability.

--- middle

#  Introduction

This document specifies algorithm profiles for SUIT manifest parsers and authors to ensure better interoperability. These profiles apply specifically to a constrained node software update use case. Mandatory algorithms may change over time due to an evolving threat landscape. Algorithms are grouped into algorithm profiles to account for this. Profiles may be deprecated over time. SUIT will define five choices of Mandatory To Implement (MTI) profile specifically for constrained node software update. These profiles are:

* One Symmetric MTI profile
* Two "Current" Constrained Asymmetric MTI profiles
* Two "Current" AEAD Asymmetric MTI profiles
* One "Future" Constrained Asymmetric MTI profile

At least one MTI algorithm in each category MUST be FIPS qualified.

Because SUIT presents an asymmetric communication profile, where manifest authors have unlimited resources and manifest recipients have constrained resources, the requirements for Recipients and Authors are different.

Recipients MAY choose which MTI profile they wish to implement. It is RECOMMENDED that they implement the "Future" Asymmetric MTI profile. Recipients MAY implement any number of other profiles. Recipients MAY choose not to implement an encryption algorithm if encrypted payloads will never be used.

Authors MUST implement all MTI profiles. Authors MAY implement any number of other profiles.

This draft 'makes use of AES-CTR with a digest algorithm in COSE as specified in ({{-ctrcbc}}). AES-CTR is used because it enables out-of-order reception and decryption of blocks, which is necessary for some constrained node use cases. Out-of-order reception with on-the-fly decryption is not available in the preferred encryption algorithms.
Authenticated Encryption with Additional Data (AEAD) is preferred over un-authenticated encryption and an AEAD profile SHOULD be selected wherever possible. See Security Considerations in this draft ({{aes-ctr-payloads}}) and in {{-ctrcbc}} (Section 8) for additional details on the considerations for the use of AES-CTR.

Other use-cases of the SUIT Manifest ({{I-D.ietf-suit-manifest}}) MAY define their own MTI algorithms.

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

## Current Constrained Asymmetric MTI Profile 1: suit-sha256-esp256-ecdh-a128ctr {#suit-sha256-esp256-ecdh-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | ESP256 | -9 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128CTR | -65534 |

## Current Constrained Asymmetric MTI Profile 2: suit-sha256-eddsa-ecdh-a128ctr {#suit-sha256-eddsa-ecdh-a128ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | Ed25519 | -50 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128CTR | -65534 |

## Current AEAD Asymmetric MTI Profile 1: suit-sha256-esp256-ecdh-a128gcm {#suit-sha256-esp256-ecdh-a128gcm}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | ESP256 | -9 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128GCM | 1 |

## Current AEAD Asymmetric MTI Profile 2: suit-sha256-ed25519-ecdh-chacha-poly {#suit-sha256-ed25519-ecdh-chacha-poly}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | Ed25519 | -50 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | ChaCha20/Poly1305 | 24 |


## Future Constrained Asymmetric MTI Profile 1: suit-sha256-hsslms-a256kw-a256ctr {#suit-sha256-hsslms-a256kw-a256ctr}

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | HSS-LMS | -46 |
| Key Exchange | A256KW | -5 |
| Encryption | A256CTR | -65532 |

The decision as to how deep the tree is, is a decision that affects authoring tools only.
Verification is not affected by the choice of the "W" parameter, but the size of the signature is affected.
In order to support long lifetimes needed by IoT device, deep trees are RECOMMENDED.


# Reporting Profiles

When using Manifest Recipients Response communication, particularly data structures that are designed for reporting of update capabilities, status, progress, or success, the same profile as the is used on the SUIT manifest SHOULD be used. There are cases where this is not possible, such as suit-sha256-hsslms-a256kw-a256ctr. In this case, the closest equivalent profile SHOULD be used, for example suit-sha256-esp256-ecdh-a128ctr.

# Security Considerations {#security}

Payload encryption is often used to protect Intellectual Property (IP) and Personally Identifying Information (PII) in transit. The primary function of payload in SUIT is to act as a defense against passive IP and PII snooping. By encrypting payloads, confidential IP and PII can be protected during distribution. However, payload encryption of firmware or software updates of a commodity device is not a cybersecurity defense against targetted attacks on that device.

## Payload encryption as a cybersecurity defense

To define the purpose of payload encryption as a defensive cybersecurity tool, it is important to define the capabilities of modern threat actors. A variety of capabilities are possible:

* find bugs by binary code inspection
* send unexpected data to communication interfaces, looking for unexpected behavior
* use fault injection to bypass or manipulate code
* use communication attacks or fault injection along with gadgets found in the code

Given this range of capabilities, it is important to understand which capabilities are impacted by firmware encryption. Threat actors who find bugs by manual inspection or use gadgets found in the code will need to first extract the code from the target. In the IoT context, it is expected that most threat actors will start with sample devices and physical access to test attacks.

Due to these factors, payload encryption serves to limit the pool of attackers to those who have the technical capability to extract code from physical devices and those who perform code-free attacks.

## Use of AES-CTR in payload encryption {#aes-ctr-payloads}

AES-CTR mode with a digest is specified, see {{-ctrcbc}}. All of the AES-CTR security considerations in {{-ctrcbc}} apply. A non-AEAD encryption mode is specified in this draft due to the following mitigating circumstances:

* Out-of-order decryption must be supported. Therefore, we must use a stream cipher that supports random access.
* Chosen plaintext attacks are extremely difficult to achieve, since the payloads are typically constructed in a relatively secure environment--the developer's computer or build infrastructure--and should be signed in an air-gapped or similarly protected environment. In short, the plaintext is authenticated prior to encryption.
* Content Encryption Keys must be used to encrypt only once. See {{I-D.ietf-suit-firmware-encryption}}.

As a result of these mitigating circumstances, AES-CTR is an acceptable cipher for typical software/firmware delivery scenarios.

# IANA Considerations

IANA is requested to create a page for COSE Algorithm Profiles within
the category for Software Update for the Internet of Things (SUIT)

IANA is also requested to create a registry for COSE Alforithm Profiles
within this page. The initial content of the registry is:

| Profile | Status | Digest | Auth | Key Exchange | Encryption | Descriptor Array | Reference
|====|
| suit-sha256-hmac-a128kw-a128ctr    | MANDATORY | -16 | 5   | -3  | -65534 | \[-16,   5,  -3, -65534\] | {{suit-sha256-hmac-a128kw-a128ctr}}
| suit-sha256-esp256-ecdh-a128ctr    | MANDATORY | -16 | -7  | -29 | -65534 | \[-16,  -7, -29, -65534\] | {{suit-sha256-esp256-ecdh-a128ctr}}
| suit-sha256-eddsa-ecdh-a128ctr     | MANDATORY | -16 | -8  | -29 | -65534 | \[-16,  -8, -29, -65534\] | {{suit-sha256-eddsa-ecdh-a128ctr}}
| suit-sha256-esp256-ecdh-a128gcm    | MANDATORY | -16 | -7  | -29 | 1      | \[-16,  -7, -29,      1\] | {{suit-sha256-esp256-ecdh-a128gcm}}
| suit-sha256-eddsa-ecdh-chacha-poly | MANDATORY | -16 | -8  | -29 | 24     | \[-16,  -8, -29,     24\] | {{suit-sha256-eddsa-ecdh-chacha-poly}}
| suit-sha256-hsslms-a256kw-a256ctr  | MANDATORY | -16 | -46 | -5  | -65532 | \[-16, -46,  -5, -65532\] | {{suit-sha256-hsslms-a256kw-a256ctr}}

New entries to this registry require Standards Action.

A recipient device that claims conformance to this document will have implemented at least one of the above algorithms.

As time progresses, if entries are removed from mandatory status, they will become SHOULD, MAY and then possibly NOT RECOMMENDED for new implementation.  However, as it may be impossible to update the SUIT manifest processor in the field, support for all relevant algorithms will almost always be required by authoring tools.

When new algorithms are added by subsequent documents, the device and authoring tools will then claim conformance to those new documents.

--- back

# A. Full CDDL {#full-cddl}

The following CDDL creates a subset of COSE for use with SUIT. Both tagged and untagged messages are defined. SUIT only uses tagged COSE messages, but untagged messages are also defined for use in protocols that share a ciphersuite with SUIT.

To be valid, the following CDDL MUST have the COSE CDDL appended to it. The COSE CDDL can be obtained by following the directions in {{-cose, Section 1.4}}.

~~~ CDDL
{::include draft-ietf-suit-mti.cddl}
~~~
