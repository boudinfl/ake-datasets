#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys

with open(sys.argv[1], 'r') as f:
	text = []
	for line in f:
		if not line.startswith('\t'):
			text.append(line.strip())
		else:
			text[-1] += " " + line.strip()

	with open(sys.argv[2], 'w') as o:
		o.write("\n".join([re.sub('\s+', ' ', l).strip() for l in text]))