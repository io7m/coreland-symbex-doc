#!/bin/sh

SOURCE="${HOME}/git/coreland/posix-ada/"

fatal()
{
  echo "fatal: $1" 1>&2
  exit 1
}

info()
{
  echo "info: $1" 1>&2
}

#
# Error type definition.
#

info "building error type"

error_values=`awk -F: '{print $NF}' < ${SOURCE}/errno_to_ada.map`
printf 'type Error_t is\n'   >> src/a-posix-error-types-error_t.ud.tmp || exit 1
printf '  (Error_None,\n'    >> src/a-posix-error-types-error_t.ud.tmp || exit 1
for value in ${error_values}
do
  echo "   Error_${value},"  >> src/a-posix-error-types-error_t.ud.tmp || exit 1
done
printf ");\n"                >> src/a-posix-error-types-error_t.ud.tmp || exit 1

mv src/a-posix-error-types-error_t.ud.tmp \
   src/a-posix-error-types-error_t.ud || exit 1

#
# Make procedure map
#

info "building procedure map"

cat >> src/m_proc_map.ud.tmp <<EOF
(table procedure_map
  (t-row (item "POSIX API") (item "Ada equivalent"))
EOF

(
for spec in ${SOURCE}/posix*.ads
do
  info "processing $spec"
  ./make-proc_map.lua "$spec" || fatal "could not create proc map for $spec"
done
) | sort -k 3 >> src/m_proc_map.ud.tmp

echo ")" >> src/m_proc_map.ud.tmp

mv src/m_proc_map.ud.tmp src/m_proc_map.ud || fatal "could not replace m_proc_map.ud"

#
# Copy Z images.
#

rsync -avz src/Z release/ || fatal "could not rsync Z images"
