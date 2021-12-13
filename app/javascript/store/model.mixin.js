import { SELECTED, SELECT, UNSELECT, FETCH, FETCH_BY_ID, CLEAR, SEARCH, PATCH_FIELDS, SAVE } from "./model.store";
import { mapActions } from 'vuex';
import { toastMixin } from "@/mixins";
import { SAVE_SUCCESS } from "@/constants/strings";

export const modelMixin = {
  mixins: [
    toastMixin
  ],
  props: {
    model: {
      type: String,
      required: true
    }
  },
  computed: {
    selected() {
      return this.$store.getters[SELECTED]({model: this.model})
    },
    collection() {
      return Object.values(this.$store.getters['jv/get']({_jv: { type: this.model }}))
    }
  },
  methods: {
    ...mapActions('jv', ['get']),
    ...mapActions('jv', ['search']),
    select(itemOrId) {
      this.$store.commit(SELECT, {model: this.model, itemOrId});
    },
    unselect() {
      this.$store.commit(UNSELECT, {model: this.model});
    },
    fetchSelected() {
      return this.$store.dispatch(FETCH_SELECTED, {model: this.model});
    },
    fetch(params) {
      return this.$store.dispatch(FETCH, {model: this.model, params});
    },
    fetch_by_id(id) {
      return this.$store.dispatch(FETCH_BY_ID, {model: this.model, id: id});
    },
    search(params) {
      return this.$store.dispatch(SEARCH, {model: this.model, params});
    },
    clear() {
      return this.$store.dispatch(CLEAR, {model: this.model});
    },
    saveSelected() {
      return this.toastPromise(this.$store.dispatch(SAVE, {model: this.model, item: this.selected}), SAVE_SUCCESS(this.model));
    },
    patchSelected(data) {
      return this.toastPromise(this.$store.dispatch(PATCH_FIELDS, {model: this.model, item: {...this.selected, ...data}, fields: Object.keys(data), selected: false}), SAVE_SUCCESS(this.model));
    }
  }
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
    modelMixin
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
