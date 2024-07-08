# -*- coding: utf-8 -*-
# ----------------------------------------------------------------------------
# Copyright 2022 ARM Limited or its affiliates
#
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------

MD_FILE := draft-ietf-suit-mti.md
DRAFT := $(shell grep 'docname: ' $(MD_FILE) | awk '{print $$2}')

all: $(DRAFT).xml $(DRAFT).txt $(DRAFT).html

$(DRAFT).html: $(DRAFT).xml
	xml2rfc $(DRAFT).xml --html

$(DRAFT).txt: $(DRAFT).xml
	xml2rfc $(DRAFT).xml

$(DRAFT).xml: $(MD_FILE)
	kramdown-rfc2629 $(MD_FILE) > $(DRAFT).xml

.PHONY: clean
clean:
	rm -fr $(DRAFT).xml $(DRAFT).txt $(DRAFT).html
