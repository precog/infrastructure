name "attacker"
description 'ReportGrid QA attacker role'
run_list "role[base]", "recipe[iptables]", "recipe[java]", "recipe[jmeter]"
