import { SELECTED, SELECT, UNSELECT, FETCH, FETCH_BY_ID, FETCH_SELECTED, CLEAR, SEARCH, PATCH_FIELDS, SAVE, DELETE, FETCH_NEXT_PAGE, FETCH_PREV_PAGE, SELECT_NEXT, SELECT_PREV, SELECT_FIRST, FULL_TOTAL, SELECTED_INDEX } from "./model.store";
import { mapActions } from 'vuex';
import { toastMixin } from "@/mixins";
import { MODEL_SAVE_ERROR, MODEL_SAVE_SUCCESS, MODEL_DELETE_SUCCESS, MODEL_DELETE_ERROR, SPECIFIC_MODEL_SAVE_ERROR, SPECIFIC_MODEL_SAVE_SUCCESS } from "@/constants/strings";

export const modelMixinNoProp = {
  mixins: [
    toastMixin
  ],
  computed: {
    selected() {
      return this.$store.getters[SELECTED]({model: this.model})
    },
    collection() {
      return Object.values(this.$store.getters['jv/get']({_jv: { type: this.model }}))
    },
    fullTotal() {
      return this.$store.getters[FULL_TOTAL]({model: this.model})
    },
    selectedOrdinal() {
      return this.$store.getters[SELECTED_INDEX]({model: this.model}) + 1;
    }
  },
  methods: {
    ...mapActions('jv', ['get']),
    ...mapActions('jv', ['search']),
    select(itemOrId) {
      this.$store.commit(SELECT, {model: this.model, itemOrId});
    },
    selectNext() {
      return this.$store.dispatch(SELECT_NEXT, {model: this.model});
    },
    selectPrev() {
      return this.$store.dispatch(SELECT_PREV, {model: this.model});
    },
    selectFirst() {
      this.$store.commit(SELECT_FIRST, {model: this.model});
    },
    unselect() {
      this.$store.commit(UNSELECT, {model: this.model});
    },
    fetchSelected() {
      return this.$store.dispatch(FETCH_SELECTED, {model: this.model});
    },
    fetch(params, url = null) {
      return this.$store.dispatch(FETCH, {model: this.model, url: url, params});
    },
    fetchNextPage() {
      return this.$store.dispatch(FETCH_NEXT_PAGE, {model: this.model, url: url, params});
    },
    fetchPrevPage() {
      return this.$store.dispatch(FETCH_PREV_PAGE, {model: this.model, url: url, params});
    },
    fetch_by_id(id) {
      return this.$store.dispatch(FETCH_BY_ID, {model: this.model, id: id});
    },
    // TODO: model needs to be passed in
    search(params) {
      return this.$store.dispatch(SEARCH, {model: this.model, params});
    },
    clear() {
      // NOTE: this is a sync tx not async, it is not trigerring the computed collection?
      this.$store.commit(CLEAR, {model: this.model});
    },
    saveSelected() {
      return this.toastPromise(this.$store.dispatch(SAVE, {model: this.model, item: this.selected}), MODEL_SAVE_SUCCESS(this.model), MODEL_SAVE_ERROR(this.model));
    },
    patchSelected(data, selected = false, success_text = undefined, error_text = undefined) {
      return this.patch(this.selected, data, selected, success_text, error_text);
    },
    patch(instance, data, selected = false, success_text = undefined, error_text = undefined) {
      if (!success_text) {
        success_text = MODEL_SAVE_SUCCESS(this.model)
      }
      if (!error_text) {
        error_text = MODEL_SAVE_ERROR(this.model)
      }
      return this.toastPromise(this.$store.dispatch(PATCH_FIELDS, {model: this.model, item: {...instance, ...data}, fields: Object.keys(data), selected}), success_text, error_text);
    },
    // need a save instance
    save(instance) {
      return this.toastPromise(this.$store.dispatch(SAVE, {model: this.model, selected: false, item: instance}), MODEL_SAVE_SUCCESS(this.model), MODEL_SAVE_ERROR(this.model));
    },
    delete_by_id(id) {
      return this.toastPromise(this.$store.dispatch(DELETE, {model: this.model, itemOrId: id}), MODEL_DELETE_SUCCESS(this.model), MODEL_DELETE_ERROR(this.model));
    },
    delete(item) {
      return this.toastPromise(this.$store.dispatch(DELETE, {model: this.model, itemOrId: item}), MODEL_DELETE_SUCCESS(this.model), MODEL_DELETE_ERROR(this.model));
    },
  }
}

export const modelMixin = {
  mixins:[
    modelMixinNoProp
  ],
  props: {
    model: {
      type: String,
      required: true
    }
  },
}

/**
 * Returns a mixin that provides a mirrored copy of the given field in
 * currently selected model, which updates when the selected
 * model updates.
 *
 * Provides:
 * data: { [field]: null }
 * mounted & watch on selected[field]
 *
 *  See people/people_admin_tab.vue for a good example
 *
 * @param {string} field
 * @returns The field mixin.
 */
export const makeSelectedFieldMixin = (field) => ({
  mixins: [
    modelMixinNoProp
  ],
  data: () => ({
    [field]: null
  }),
  mounted() {
    if (this.selected) {
      this[field] = this.selected[field];
    }
  },
  watch: {
    selected(newVal, oldVal) {
      if (newVal && (!oldVal || oldVal[field] !== newVal[field])) {
        this[field] = newVal[field];
      }
    }
  }
})

/* obsolete
const mapStateHelper = (mapState) => {
  let states = mapState;
  if (Array.isArray(mapState)) {
    states = mapState.reduce((p, c) => ({...p, [c]: c}), {})
  }
  return Object.keys(states).reduce((p, c) => ({...p, [c]: function() {
    let baseState = this.$store.state;
    if (this.namespace) {
      let namespaceBits = this.namespace.split('/');
      baseState = namespaceBits.reduce((p, c) => p[c], baseState)
    }
    return baseState[c];
  }}), {})
}

const mapMutationsHelper = (mapMutations) => {
  let mutations = mapMutations;
  if (Array.isArray(mapMutations)) {
    mutations = mapMutations.reduce((p, c) => ({...p, [c]: c}), {})
  }
  return Object.keys(mutations).reduce((p, c) => ({...p, [c]: function() {
    console.log("i get here", "arguments", arguments, "this", this)
    let mutationName = this.namespace ? `${this.namespace}/${c}` : c;
    return this.commit(mutationName, ...arguments);
  }}), {})
}

const mapActionsHelper = (mapActions) => {
  let actions = mapActions;
  if (Array.isArray(mapActions)) {
    actions = mapActions.reduce((p, c) => ({...p, [c]: c}), {})
  }
  return Object.keys(actions).reduce((p, c) => ({...p, [c]: function(...args) {
    let actionName = this.namespace ? `${this.namespace}/${c}` : c;
    return this.dispatch(actionName, ...args);
  }}), {})
}
*/
export default modelMixin;
