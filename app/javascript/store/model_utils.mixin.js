/*
 This exists because we need to have access to some model methods without
 needing to set the prop in the component
**/
import { FETCH_BY_ID } from "./model.store";

export const modelUtilsMixin = {
  methods: {
    fetch_model_by_id(model, id) {
      return this.$store.dispatch(FETCH_BY_ID, {model: model, id: id});
    },
  }
}

export default modelUtilsMixin;
