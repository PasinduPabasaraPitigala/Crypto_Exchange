response=$(curl -s http://localhost:30001)
if [[ "$response" == *"Start Coin Base Exchange Service"* ]]; then
  echo "Green Deployment Passed!"
else
  echo "Green Deployment Failed!" && exit 1
fi