function mkcd --description 'Create directory and change to it'
    mkdir -pv $argv
    cd $argv
end
