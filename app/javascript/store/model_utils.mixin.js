/*
 This exists because we need to have access to some model methods without
 needing to set the prop in the component
**/
import { FETCH_BY_ID, DELETE } from "./model.store";
import { MODEL_SAVE_ERROR, MODEL_SAVE_SUCCESS, MODEL_DELETE_SUCCESS, MODEL_DELETE_ERROR } from "@/constants/strings";

export const modelUtilsMixin = {
  methods: {
    fetch_model_by_id(model, id) {
      return this.$store.dispatch(FETCH_BY_ID, {model: model, id: id});
    },
    delete_model_by_id(model, id) {
      return this.toastPromise(this.$store.dispatch(DELETE, {model: model, itemOrId: id}), MODEL_DELETE_SUCCESS(model), MODEL_DELETE_ERROR(model));
    }
  }
}

export default modelUtilsMixin;
