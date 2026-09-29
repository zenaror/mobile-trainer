# Hold-out experiment (tools/mapper.py --holdout)

training scenarios (9): help, hotplug, mail_compose, mail_profile, monkey_1, monkey_3, noadapter, register_neterr, title_settings
held-out scenarios (9): homepage, mail_addressbook, mail_mailbox, mail_server, monkey_2, monkey_blank, register, resume_registration, tutorial_profile
instructions executed by the held-out scenarios only (bank != 00): 8519 (34740 starts executed by the training half)

## classification of the held-out-only executed instructions by the map built from the training half

* hit as instruction start, region PROBABLE: 8306 (97.5%)
* miss: in unclassified region: 213 (2.5%)

## PROBABLE code instruction starts of the training map, checked against the union of all 18 scenarios

* PROBABLE start not executed by any trace: 59077 (87.7%)
* PROBABLE start confirmed by a later trace (executed start): 8306 (12.3%)
