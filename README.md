# SUIT-MTI
Mandatory-to-Implement Algorithms for Authors and Recipients of Software Update for the Internet of Things manifests

* [draft-ietf-suit-mti](./draft-ietf-suit-mti.md)

## Converting draft from md file

### Prerequisite packages

Requires two packages:
```
kramdown-rfc2629 by Ruby
xml2rfc by Python
```

Installing required packages on Fedora
```
sudo dnf makecache
sudo dnf -y install python3-pip git make gem
gem install kramdown-rfc2629
pip3 install xml2rfc
```

Installing required packages on Ubuntu
```
sudo apt-get update
sudo apt-get -y install python3-pip ruby git curl
pip3 install xml2rfc
gem install kramdown-rfc2629
```

### Generating draft from a markdown file

```
git clone https://github.com/suit-wg/suit-mti.git
cd suit-mti
make
```

It will create `draft-ietf-suit-mti-latest.txt` and
`draft-ietf-suit-mti-latest.xml`.

## Submitting draft

TBD
