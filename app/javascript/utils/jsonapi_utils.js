export const getOrderedRelationships = (relationship_name, target) => {
  let rel_objects = target[relationship_name];
  if (!rel_objects) return [];
  let order = target._jv.relationships[relationship_name].data.map(i => i.id);
  return Object.values(rel_objects).sort((a, b) => order.indexOf(a.id) - order.indexOf(b.id));
}
