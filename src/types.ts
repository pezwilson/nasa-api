export interface NASAResponse {
  near_earth_objects: {
    [date: string]: NearEarthObject[];
  };
}

export interface NearEarthObject {
  name: string;
  estimated_diameter: {
    kilometers: {
      estimated_diameter_min: number;
      estimated_diameter_max: number;
    };
  };
  close_approach_data: CloseApproachData[];
}

export interface CloseApproachData {
  miss_distance: {
    kilometers: string;
  };
  relative_velocity: {
    kilometers_per_hour: string;
  };
}

// Output interface for transformed data
export interface AsteroidData {
  name: string;
  size: {
    min_km: number;
    max_km: number;
    average_km: number;
  };
  closeness_to_earth_km: number;
  relative_velocity_kmh: number;
}
