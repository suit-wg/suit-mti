---
title: Cryptographic Algorithm Recommendations for Software Updates of Internet of Things Devices
abbrev: SUIT Algorithm Recommendations
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
      asciiInitials: O. Ronningstad
      name: Øyvind Rønningstad
      asciiFullname: Oyvind Ronningstad
      organization: Nordic Semiconductor
      email: oyvind.ronningstad@gmail.com
 -
      ins: A. Tsukamoto
      name: Akira Tsukamoto
      organization: Openchip & Software Technologies, S.L.
      email: akira.tsukamoto@gmail.com

normative:
  RFC8778:
  RFC9052: cose
  RFC9459: ctrcbc
  I-D.ietf-suit-manifest:

informative:
  I-D.ietf-suit-firmware-encryption:
  I-D.ietf-suit-report:
  RFC9053:
  RFC9019:
  IANA-COSE:
    title: "CBOR Object Signing and Encryption (COSE)"
    author:
    date: 2022
    target: https://www.iana.org/assignments/cose/cose.xhtml

--- abstract

This document specifies cryptographic algorithm profiles to be used with the Software Updates for Internet of Things (SUIT) manifest.
These profiles define mandatory-to-implement algorithms to ensure interoperability.

--- middle

#  Introduction

This document defines algorithm profiles for SUIT manifest parsers and authors to promote interoperability in constrained node software update scenarios. These profiles specify sets of mandatory-to-implement (MTI) algorithms tailored to the evolving security landscape, acknowledging that cryptographic requirements may change over time. To accommodate this, algorithms are grouped into profiles, which may be updated or deprecated as needed.

This document defines the following MTI profiles for constrained environments:

* One symmetric profile
* Two constrained asymmetric profiles
* Two asymmetric profiles utilizing Authenticated Encryption with Associated Data (AEAD) ciphers
* One constrained asymmetric profile utilizing a hash-based signature scheme

Due to the asymmetric nature of SUIT deployments (where manifest authors are typically resource-rich and recipients are resource-constrained) the cryptographic requirements differ for each role.

This specification uses AES-CTR in combination with a digest algorithm, as defined in {{-ctrcbc}}, to support use cases that require out-of-order block reception and decryption-capabilities not offered by AEAD algorithms. For further discussion of these constrained use cases, see {{aes-ctr-payloads}}. Other SUIT use cases (see {{I-D.ietf-suit-manifest}}) may define different profiles.

# Conventions and Definitions

{::boilerplate bcp14-tagged}

This specification uses the following abbreviations:

- Advanced Encryption Standard (AES)
- AES Counter (AES-CTR) Mode
- AES Key Wrap (AES-KW)
- Authenticated Encryption with Associated Data (AEAD)
- Concise Binary Object Representation (CBOR)
- CBOR Object Signing and Encryption (COSE)
- Concise Data Definition Language (CDDL)
- Elliptic Curve Diffie-Hellman Ephemeral-Static (ECDH-ES)  
- Hash-based Message Authentication Code (HMAC)
- Hierarchical Signature System / Leighton-Micali Signature (HSS/LMS)
- Software Updates for Internet of Things (SUIT)

SUIT specifically addresses the requirements of constrained devices and networks, as described in {{RFC9019}}.
The terms "Author", "Recipient", and "Manifest" are defined in {{I-D.ietf-suit-manifest}}. 

# Profiles

Each profile consist of algorithms from the following categories:

* Digest Algorithms
* Authentication Algorithms
* Key Exchange Algorithms (optional)
* Encryption Algorithms (optional)

Each profile references specific algorithm identifiers, as defined in {{IANA-COSE}}.
Since these algorithm identifiers are used in the context of the IETF SUIT manifest {{I-D.ietf-suit-manifest}}, they are represented using CBOR Object Signing and Encryption (COSE) structures as defined in {{RFC9052}} and {{RFC9053}}.

The use of the profiles by authors and recipients is based on the following assumptions:

- Recipients MAY choose which MTI profile they wish to implement. It is RECOMMENDED that they implement the `suit-sha256-hsslms-a256kw-a256ctr` profile. Recipients MAY implement any number of other profiles not defined in this document. Recipients MAY choose not to implement encryption and the corresponding key exchange algorithms if they do not intend to support encrypted payloads.

- Authors MUST implement all profiles with a status set to 'MANDATORY' in {{iana}}. Authors MAY implement any number of additional profiles.

## Profile `suit-sha256-hmac-a128kw-a128ctr` {#suit-sha256-hmac-a128kw-a128ctr}

This profile only offers support for symmetric cryptographic algorithms. 

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | HMAC-256 | 5 |
| Key Exchange | A128KW Key Wrap | -3 |
| Encryption | A128CTR | -65534 |

## Profile `suit-sha256-esp256-ecdh-a128ctr` {#suit-sha256-esp256-ecdh-a128ctr}

This profile supports asymmetric algorithms for use with constrained devices. 

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | ESP256 | -9 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128CTR | -65534 |

## Profile `suit-sha256-ed25519-ecdh-a128ctr` {#suit-sha256-ed25519-ecdh-a128ctr}

This profile supports an alternative choice of asymmetric algorithms for use with constrained devices. 

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | Ed25519 | -19 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128CTR | -65534 |

## Profile `suit-sha256-esp256-ecdh-a128gcm` {#suit-sha256-esp256-ecdh-a128gcm}

This profile supports asymmetric algorithms in combination with AEAD algorithms.

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | ESP256 | -9 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | A128GCM | 1 |

## Profile `suit-sha256-ed25519-ecdh-chacha-poly` {#suit-sha256-ed25519-ecdh-chacha-poly}

This profile also supports asymmetric algorithms with AEAD algorithms but offers an alternative to `suit-sha256-esp256-ecdh-a128gcm`.

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | Ed25519 | -19 |
| Key Exchange | ECDH-ES + A128KW | -29 |
| Encryption | ChaCha20/Poly1305 | 24 |

## Profile `suit-sha256-hsslms-a256kw-a256ctr` {#suit-sha256-hsslms-a256kw-a256ctr}

This profile utilzes a stateful hash-based signature algorithm, namely the Hierarchical Signature System / Leighton-Micali Signature (HSS/LMS), as a unique alternative to the  profiles listed above.

A note regarding the use of the HSS/LMS: The decision as to how deep the tree is, is a decision that affects authoring tools only (see {{RFC8778}}).
Verification is not affected by the choice of the "W" parameter, but the size of the signature is affected. To support the long lifetimes required by IoT devices, it is RECOMMENDED to use trees with greater height (see Section 2.2 of {{RFC8778}}).

| Algorithm Type | Algorithm | COSE Key |
|============|
| Digest | SHA-256 | -16 |
| Authentication | HSS/LMS | -46 |
| Key Exchange | A256KW | -5 |
| Encryption | A256CTR | -65532 |

# Reporting Profiles

When using SUIT reports {{I-D.ietf-suit-report}} - particularly those data structures intended to convey update capabilities, status, progress, or success - the same algorithm profile as used in the corresponding SUIT manifest SHOULD be applied.
In cases where this is not feasible, such as when using the profile suit-sha256-hsslms-a256kw-a256ctr, an algorithm profile with similar security strength SHOULD be used instead, for example, suit-sha256-esp256-ecdh-a128ctr. There may be cases
where switching to a different algorithm profile is not possible and where SUIT report functionality has to be disabled.

# Security Considerations {#security}

Payload encryption is used to protect machine learning models, specifical algorithms and Personally Identifying Information (PII) in transit. The primary function of payload in SUIT is to act as a defense against snooping. By encrypting payloads, confidential content can be protected during distribution. However, payload encryption of firmware or software updates of a commodity device is not a cybersecurity defense against targetted attacks on that device.

## Payload Encryption as Part of a Defense-in-Depth Strategy

To define the purpose of payload encryption as a defensive cybersecurity tool, it is important to define the capabilities of modern threat actors. A variety of capabilities are possible:

* find bugs by binary code inspection
* send unexpected data to communication interfaces, looking for unexpected behavior
* use fault injection to bypass or manipulate code
* use communication attacks or fault injection along with gadgets found in the code

Given this range of capabilities, it is important to understand which capabilities are impacted by firmware encryption. Threat actors who find bugs by manual inspection or use gadgets found in the code will need to first extract the code from the target. In the IoT context, it is expected that most threat actors will start with sample devices and physical access to test attacks.

Due to these factors, payload encryption serves to limit the pool of attackers to those who have the technical capability to extract code from physical devices and those who perform code-free attacks.

## Use of AES-CTR in Payload Encryption {#aes-ctr-payloads}

AES-CTR mode with a digest is specified, see {{-ctrcbc}}. All of the AES-CTR security considerations in {{-ctrcbc}} apply. See {{I-D.ietf-suit-firmware-encryption}} for additional background information.

# IANA Considerations {#iana}

IANA is requested to create a page for "COSE SUIT Algorithm Profiles" within
the category for Software Update for the Internet of Things (SUIT). IANA
is also requested to create a registry for "COSE SUIT Algorithm Profiles"
within this page.

The initial content of the "COSE SUIT Algorithm Profiles" registry is:

## Profile: `suit-sha256-hmac-a128kw-a128ctr`

- Profile: `suit-sha256-hmac-a128kw-a128ctr`
- Status: MANDATORY  
- Digest: -16  
- Auth: 5  
- Key Exchange: -3  
- Encryption: -65534  
- Descriptor Array: `[-16, 5, -3, -65534]`  
- Reference: Section 3.1

## Profile: `suit-sha256-esp256-ecdh-a128ctr`

- Profile: `suit-sha256-esp256-ecdh-a128ctr`
- Status: MANDATORY  
- Digest: -16  
- Auth: -9  
- Key Exchange: -29  
- Encryption: -65534  
- Descriptor Array: `[-16, -9, -29, -65534]`  
- Reference: Section 3.2

## Profile: `suit-sha256-ed25519-ecdh-a128ctr`

- Profile: `suit-sha256-ed25519-ecdh-a128ctr`
- Status: MANDATORY  
- Digest: -16  
- Auth: -19  
- Key Exchange: -29  
- Encryption: -65534  
- Descriptor Array: `[-16, -19, -29, -65534]`  
- Reference: Section 3.3

## Profile: `suit-sha256-esp256-ecdh-a128gcm`

- Profile: `suit-sha256-esp256-ecdh-a128gcm`
- Status: MANDATORY  
- Digest: -16  
- Auth: -9  
- Key Exchange: -29  
- Encryption: 1  
- Descriptor Array: `[-16, -9, -29, 1]`  
- Reference: Section 3.4

## Profile: `suit-sha256-ed25519-ecdh-chacha-poly`

- Profile: `suit-sha256-ed25519-ecdh-chacha-poly`
- Status: MANDATORY  
- Digest: -16  
- Auth: -19  
- Key Exchange: -29  
- Encryption: 24  
- Descriptor Array: `[-16, -19, -29, 24]`  
- Reference: Section 3.5

## Profile: `suit-sha256-hsslms-a256kw-a256ctr`

- Profile: `suit-sha256-hsslms-a256kw-a256ctr`
- Status: MANDATORY  
- Digest: -16  
- Auth: -46  
- Key Exchange: -5  
- Encryption: -65532  
- Descriptor Array: `[-16, -46, -5, -65532]`  
- Reference: Section 3.6

While most profile attributes are self-explanatory, the status field warrants a brief explanation.
This field can take one of three values: MANDATORY, NOT RECOMMENDED, or OPTIONAL.

- MANDATORY indicates that the profile is mandatory to implement (MTI) for manifest authors.
- NOT RECOMMENDED means that the profile should generally be avoided in new implementations.
- OPTIONAL suggests that support for the profile is permitted but not required; it is not part of the MTI set.

Adding new profiles or updating the status of existing profiles requires Standards Action.

As time progresses, algorithm profiles may loose their MANDATORY status. Then, their status will become
either OPTIONAL or NOT RECOMMENDED for new implementations. However, as it may be impossible to update
the SUIT manifest processor in the field, support for all relevant algorithms will almost always be
required by authoring tools.

--- back

# Full CDDL {#full-cddl}

The following CDDL creates a subset of COSE for use with SUIT. Both tagged and untagged messages are defined. SUIT only uses tagged COSE messages, but untagged messages are also defined for use in protocols that share a ciphersuite with SUIT.

To be valid, the following CDDL MUST have the COSE CDDL appended to it. The COSE CDDL can be obtained by following the directions in {{-cose, Section 1.4}}.

~~~ CDDL
{::include-fold draft-ietf-suit-mti.cddl}
~~~

# Acknowledgments

We would like to specifically thank Magnus Nyström, Deb Cooley, Michael Richardson, Russ Housley, Michael B. Jones, Henk Birkholz, Mohamed Boucadair, Linda Dunbar, Jouni Korhonen, Lorenzo Corneo and Hannes Tschofenig for their review comments.
