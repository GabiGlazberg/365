import boto3

def list_regions():
    regions = [region['RegionName'] for region in boto3.client('ec2').describe_regions()['Regions']]
    
    services = {}

    for region in regions: 
        region_client = boto3.client('resourcegroupstaggingapi', region_name=region)
        response = region_client.get_resources()

        resources = [x.get('ResourceARN') for x in response.get('ResourceTagMappingList')]
        
        for resource in resources:
            serviceType = resource.split(':')[2]
            if serviceType not in services:
                services[serviceType] = []
            services[serviceType].append(resource)
    
    return services

if __name__ == '__main__':
    services = list_regions()
    for service, resources in services.items():
        print(f"ServoceType: {service}")
        for resource in resources:
            print(f"  - {resource}")  