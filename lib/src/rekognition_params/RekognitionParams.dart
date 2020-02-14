enum CompareFacesQualityFilter {
  NONE,
  AUTO,
  LOW,
  MEDIUM,
  HIGH,
}

class CompareFacesParams {
  CompareFacesQualityFilter qualityFilter;
  CompareFacesParams(this.qualityFilter);
}

enum DetectFacesAttributes {
  DEFAULT,
  ALL,
}

class DetectFacesParams {
  DetectFacesAttributes attributes;
  DetectFacesParams(this.attributes);
}
