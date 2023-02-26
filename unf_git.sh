# Get list of followers and following
echo  "🔍 Getting list of followers..."
gh api "/user/followers?per_page=100&page=1" | jq '.[].login' > followers.json

echo  "🔍 Getting list of following..."
gh api "/user/following?per_page=100&page=1" | jq '.[].login' > following.json

# Find unfollowers
echo  "🔍 Finding unfollowers..."
diff following.json followers.json | grep "<" | sed 's/< //' | tr -d '"' > unfollowers.json

# Unfollow unfollowers
if [[ -s "unfollowers.json" ]]; then
    echo  "🚫 Unfollowing unfollowers..."
    while read username; do gh api -X DELETE "/user/following/$username"; echo  "✅ Unfollowed $username"; done < unfollowers.json
    echo  "🎉 You've successfully unfollowed all users who don't follow you back! 🎉"
else
    echo  "😎 Congratulations, nobody is unfollowing you! 😎"

fi

# Clean up
rm -rf followers.json following.json unfollowers.json
