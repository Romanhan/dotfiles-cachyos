#!/bin/sh

mount="/"
warning=20
critical=10

df -h -P -l -BG "$mount" | awk -v warning=$warning -v critical=$critical '
/\/.*/ {
  # Add "B" to make GB instead of G
  gsub(/G/, "GB", $2)
  gsub(/G/, "GB", $3) 
  gsub(/G/, "GB", $4)

  text=$4
  tooltip="Filesystem: "$1"\rSize: "$2"\rUsed: "$3" ("$5")\rAvail: "$4"\rMounted on: "$6
  use=$5
  exit 0
}
END {
  class=""
  gsub(/%$/,"",use)
  if ((100 - use) < critical) {
    class="critical"
  } else if ((100 - use) < warning) {
    class="warning"
  }
  print "{\"text\":\""text"\", \"percentage\":"use",\"tooltip\":\""tooltip"\", \"class\":\""class"\"}"
}
'
