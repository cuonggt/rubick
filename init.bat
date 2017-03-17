@echo off

if ["%~1"]==["json"] (
    copy /-y resources\Rubick.json Rubick.json
)
if ["%~1"]==[""] (
    copy /-y resources\Rubick.yaml Rubick.yaml
)

copy /-y resources\after.sh after.sh
copy /-y resources\aliases aliases

echo Rubick initialized!
