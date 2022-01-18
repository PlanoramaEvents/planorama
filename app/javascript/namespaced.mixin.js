const namespacedMixin = (mapState = {}, mapMutations = {}, mapActions = {}) => ({
  props: {
    namespace: {
      type: String,
      default: null,
    }
  },
  computed: {
    ...mapStateHelper(mapState),
  },
  methods: {
    ...mapMutationsHelper(mapMutations),
    ...mapActionsHelper(mapActions),
  }
})

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

export default namespacedMixin;
