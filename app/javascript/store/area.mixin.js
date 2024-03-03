import { areaModel } from "./area.store";
import { FETCH } from "./model.store";

export const areaMixin = {
  mounted() {
    this.$store.dispatch(FETCH, {model: areaModel});
  },
  computed: {
    areaCollection() {
      return Object.values(this.$store.getters['jv/get']({_jv: { type: areaModel }}))
    },
    areaOptions() {
      return this.areaCollection.map(area => ({text: area.name, value: area.id}))
    }
  },
  methods: {
    areaFormatter(id) {
      return this.areaCollection.find(area => area.id === id)?.name ?? id;
    }
  }
}
