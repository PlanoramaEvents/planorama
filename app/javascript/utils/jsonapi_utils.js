export const getOrderedRelationships = (relationship_name, target) => {
  let rel_objects = target[relationship_name];
  if (!rel_objects) return [];
  let sortFunc;
  if(target._jv.relationships?.[relationship_name]) {
    let order = target._jv.relationships[relationship_name].data.map(i => i.id);
    sortFunc = (a, b) => order.indexOf(a.id) - order.indexOf(b.id)
  } else {
    // try sort order
    sortFunc = (a, b) => a.sort_order - b.sort_order
  }
  return Object.values(rel_objects).sort(sortFunc);
}

export const getId = (itemOrId) => {
  try {
    return itemOrId.id || id;
  } catch {
    return itemOrId;
  }
}
