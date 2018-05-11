// term type lookups for glossary
//  each term should have a corresponding definition in definitions

export default function() {
  return {
    intervention: ["Area protection", "Resource protection/management","Land/Water management",  "Species management", "Education", "Law & Policy", "Livelihood, economic & other incentives", "External capacity building"],
    outcome: ["Material living standards", "Economic living standards", "Health", "Education", "Social relations", "Security & safety", "Governance & empowerment", "Subjective well-being", "Cultural & Spiritual", "Freedom of choice/action"],
    biome: ["Marine", "Freshwaters", "Forests", "Grasslands", "Tundra","Desert","Mangroves"],
    study: ["Before/after, control/intervention","Before/after","Change over time","Comparison group","Before/after, comparison group","Comparison group, control/intervention", "No comparator"]
  }
}