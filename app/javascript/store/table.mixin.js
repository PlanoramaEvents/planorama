import modelMixin from "./model.mixin";

export const tableMixin = {
  mixins: [modelMixin],
  props: {
    defaultSortBy: {
      type: String,
      default: null
    },
    perPage: {
      type: Number,
      default: 10
    },
    defaultFilter: {
      type: String,
      default: null
    }
  },
  data: () => ({
    sortDesc: false,
    sortBy: undefined,
    filter: null,
    currentPage: 1,
    totalRows: 0,
    correctOrder: [],
  }),
  computed: {
    sortedCollection() {
      // if we modify a single member of the collection, we no longer necessarily return the right order
      // therefore, use the order we captured at ingestion to restore the right order
      // without having to re-sort on the frontend
      return this.collection.sort((a, b) => this.correctOrder.indexOf(a?.id) - this.correctOrder.indexOf(b?.id));
    }
  },
  methods: {
    fetchPaged() {
      return new Promise((res, rej) => {
        this.fetch({
          perPage: this.perPage,
          sortOrder: this.sortDesc ? 'desc' : 'asc',
          sortBy: this.sortBy,
          filter: this.filter,
          current_page: this.currentPage,
        }).then(data => {
          // this stores some metadata that returns with the fetch call
          this.correctOrder = data._jv.json.data.map(m => m.id);
          this.currentPage = data._jv.json.meta.current_page;
          this.totalRows = data._jv.json.meta.total;
          res(data);
        }).catch(rej); // TODO maybe actually handle it here??
      })
    }
  },
  mounted() {
    this.sortBy = this.defaultSortBy;
    this.filter = this.defaultFilter;
    this.fetchPaged();
  },
  watch: {
    currentPage(newVal, oldVal) {
      console.debug("currentpage changed:", newVal, oldVal)
      // when we change the desired page to a new one, fetch again
      if(newVal != oldVal) {
        // at this point, this.currentPage reflects newVal so we don't
        // have to pass anything in here, it should just work
        this.fetchPaged();
      }
    },
    filter(newVal, oldVal) {
      console.debug("filter changed:", newVal, oldVal)
      if(newVal != oldVal) {
        this.fetchPaged();
      }
    },
    sortDesc(newVal, oldVal) {
      console.debug("sortdesc changed:", newVal, oldVal)
      if (newVal != oldVal) this.fetchPaged();
    },
    sortBy(newVal, oldVal) {
      console.debug("sortby changed:", newVal, oldVal)
      if (newVal != oldVal) this.fetchPaged();
    }
  }
}

export default tableMixin;
