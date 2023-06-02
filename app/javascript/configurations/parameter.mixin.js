import { modelMixinNoProp } from "@/mixins"

export const parameterMixin = {
  mixins: [
    modelMixinNoProp
  ],
  data: () => ({
    model: 'parameter_name'
  }),
  methods: {
    parameterByName(name) {
      return this.collection.find(p => p.parameter_name === name)
    }
  }
}
