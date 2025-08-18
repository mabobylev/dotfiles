function gcp
    read -P "Commit message: " commit_msg
    git add .
    git commit -m "$commit_msg"
    git push
end
