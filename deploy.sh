# Deploy Blue Environment
echo "Deploying Blue environment..."
kubectl apply -f deployment-blue.yaml
kubectl rollout status deployment/web-service-blue

# Expose Blue Service
kubectl apply -f service.yaml
kubectl port-forward service/web-service 30001:80 &

# Test Blue Environment
echo "Testing Blue deployment..."
curl http://localhost:30001
if [ $? -eq 0 ]; then
    echo "Blue deployment successful!"

    # Deploy Green Environment
    echo "Deploying Green environment..."
    kubectl apply -f deployment-green.yaml
    kubectl rollout status deployment/web-service-green

    # Switch Traffic to Green
    echo "Switching traffic to Green..."
    sed -i 's/coinbase-service-blue/web-service-green/' service.yaml
    kubectl apply -f service.yaml

    # Test Green Environment
    echo "Testing Green deployment..."
    curl http://localhost:30001
    if [ $? -eq 0 ]; then
        echo "Green deployment successful! Traffic switched to Green."
    else
        echo "Green deployment failed. Rolling back to Blue..."
        sed -i 's/web-service-green/web-service-blue/' service.yaml
        kubectl apply -f service.yaml
    fi
else
    echo "Blue deployment failed. Exiting."
fi
