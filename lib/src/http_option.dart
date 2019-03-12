enum CachePolicy {
    
    useProtocolCachePolicy,
    
    reloadIgnoringLocalCacheData,
    
    returnCacheDataElseLoad,
    
    returnCacheDataDontLoad
}

enum NetworkServiceType {
    
    defaultType, // Standard internet traffic
    
    voip, // Voice over IP control traffic
    
    video, // Video traffic
    
    background, // Background traffic
    
    voice, // Voice data
    
    networkServiceTypeCallSignaling // Call Signaling
}