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

It will create `draft-ietf-suit-mti.txt`, `draft-ietf-suit-mti.xml` and `draft-ietf-suit-mti.html`.

## Updating repo on GitHub

Make updates to the `draft-ietf-suit-mti.md` and/or `draft-ietf-suit-mti.cddl`.
Regenerate xml, txt and html with `make` command.

Commit and push to GitHub the changes on all files listed below.
```
draft-ietf-suit-mti.md
draft-ietf-suit-mti.cddl
```

## Submitting draft

Generate xml file containing version number only when submitting draft since the datatracker require the version number on both inside the xml and on the file name

Instead of hard coding the version number in the md file, this way will make it easier to regularly update the md and cddl file in the repo on the github by keeping the file name consistent.
Otherwise, it will require manually changing the file names back to the without version number every time when git commit and push.

1)
Revise the next line in the file ‘draft-ietf-suit-mti.md’
```
docname: draft-ietf-suit-mti
```
with adding the version number at the end for submitting the draft.
For example, If the current draft version is ‘08’ then change it as the line below.
```
docname: draft-ietf-suit-mti-09
```

2)
Generate the xml file with `make` command.
This will generate the `draft-ietf-suit-mti-09.xml` for the example above.
Upload the new xml file as the draft to the datatracker at ietf.
