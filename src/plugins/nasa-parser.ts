// src/plugins/nasa-parser.ts

// NASA API Response Types
interface EstimatedDiameter {
  kilometers: {
    estimated_diameter_min: number;
    estimated_diameter_max: number;
  };
  meters: {
    estimated_diameter_min: number;
    estimated_diameter_max: number;
  };
  miles: {
    estimated_diameter_min: number;
    estimated_diameter_max: number;
  };
  feet: {
    estimated_diameter_min: number;
    estimated_diameter_max: number;
  };
}

interface MissDistance {
  astronomical: string;
  lunar: string;
  kilometers: string;
  miles: string;
}

interface RelativeVelocity {
  kilometers_per_second: string;
  kilometers_per_hour: string;
  miles_per_hour: string;
}

interface CloseApproachData {
  close_approach_date: string;
  close_approach_date_full: string;
  epoch_date_close_approach: number;
  relative_velocity: RelativeVelocity;
  miss_distance: MissDistance;
  orbiting_body: string;
}

interface NearEarthObject {
  links: {
    self: string;
  };
  id: string;
  neo_reference_id: string;
  name: string;
  nasa_jpl_url: string;
  absolute_magnitude_h: number;
  estimated_diameter: EstimatedDiameter;
  is_potentially_hazardous_asteroid: boolean;
  close_approach_data: CloseApproachData[];
  is_sentry_object: boolean;
  sentry_data?: string;
}

interface NASANeoResponse {
  links: {
    next: string;
    previous: string;
    self: string;
  };
  element_count: number;
  near_earth_objects: {
    [date: string]: NearEarthObject[];
  };
}

// Output interface for transformed data
export interface AsteroidData {
  name: string;
  average_size: number;
  closeness_to_earth_km: number;
  relative_velocity_kmh: number;
}

/**
 * Parse NASA NEO JSON and extract asteroid data
 */
export function parseNasaData(nasaResponse: NASANeoResponse): AsteroidData[] {
  const asteroids: AsteroidData[] = [];

  // Iterate through each date in near_earth_objects
  for (const date in nasaResponse.near_earth_objects) {
    const neoArray = nasaResponse.near_earth_objects[date];

    // Process each asteroid for this date
    for (const neo of neoArray) {
      const minSize = neo.estimated_diameter.kilometers.estimated_diameter_min;
      const maxSize = neo.estimated_diameter.kilometers.estimated_diameter_max;
      const avgSize = (minSize + maxSize) / 2;

      // Get the first close approach data
      const closeApproach = neo.close_approach_data[0];

      asteroids.push({
        name: neo.name,
        average_size: avgSize,
        closeness_to_earth_km: parseFloat(closeApproach.miss_distance.kilometers),
        relative_velocity_kmh: parseFloat(closeApproach.relative_velocity.kilometers_per_hour),
      });
    }
  }

  return asteroids;
}

export type { NASANeoResponse };