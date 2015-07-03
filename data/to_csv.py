#!/usr/bin/env python
import re
import csv

name_re = re.compile(r'Running: .* ./src/Main.native -dom "([^"]*)".*(tests/.*)$')
sdsl_re = re.compile(r"\.sdsl")
strace_re = re.compile(r"\.strace")
time_re = re.compile(r"Analysis time: (\d*\.\d*) seconds")
prove_re = re.compile(r"\(\d+\) : (PASS|FAIL)")
query_re = re.compile(r"(sat|le|bot|top) *: (\d+)/(\d+)")


with open("output_sdsl.csv", "w") as fout_sdsl:
    sdsl_names = ["test", "config", "time", "pass", "fail"]
    csv_sdsl = csv.DictWriter(fout_sdsl, sdsl_names)
    csv_sdsl.writeheader()
    with open("output_strace.csv", "w") as fout_strace:
        strace_names = ["test", "config", "time", "satc", "satt", "lec", "let", "botc", "bott", "topc", "topt"]
        csv_strace =csv.DictWriter(fout_strace, strace_names)
        csv_strace.writeheader()
        with open("results.log") as fin:
            mode = [None]
            d = {}
            def flush():
                if mode[0] == "sdsl":
                    csv_sdsl.writerow(d)
                elif mode[0] == "strace":
                    csv_strace.writerow(d)
                d.clear()
                mode[0] = None
            for line in fin:
                # match a new test
                m=name_re.search(line)
                if m != None:
                    flush()
                    d["config"] = m.group(1)
                    d["test"] = m.group(2)
                    if sdsl_re.search(line) == None:
                        mode[0] = "strace"
                    else:
                        mode[0] = "sdsl"
                    continue

                #extract the time
                m=time_re.search(line)
                if m != None:
                    d["time"] = float(m.group(1))
                    continue

                if mode[0] == "sdsl":
                    # handle sdsl mode
                    m = prove_re.search(line)
                    if m != None:
                        fld = m.group(1).lower()
                        d[fld] = (d[fld] if d.has_key(fld) else 0) + 1
                    pass
                if mode[0] == "strace":
                    # handle strace mode
                    m = query_re.search(line)
                    if m != None:
                        n = m.group(1)
                        d[n+"c"] = int(m.group(2))
                        d[n+"t"] = int(m.group(3))
                        continue
                #print line
            flush()
