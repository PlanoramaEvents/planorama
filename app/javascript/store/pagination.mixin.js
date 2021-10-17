import modelMixin from "./model.mixin";

const paginationMixin = {
  mixins: [modelMixin],
  props: {
    perPage: {
      type: Number,
      default: 10
    }
  },
  data: () => ({
    sortDesc: false,
    sortBy: undefined,
    filter: undefined,
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
          page: this.currentPage,
        }).then(data => {
          // this stores some metadata that returns with the fetch call
          this.correctOrder = data._jv.json.data.map(m => m.id);
          this.currentPage = data._jv.json.meta.page;
          this.totalRows = data._jv.json.meta.total;
          res(data);
        }).catch(rej); // TODO maybe actually handle it here??
      })
    }
  },
  mounted() {
    this.fetchPaged();
  },
  watch: {
    currentPage(newVal, oldVal) {
      // when we change the desired page to a new one, fetch again
      if(newVal != oldVal) {
        // at this point, this.currentPage reflects newVal so we don't
        // have to pass anything in here, it should just work
        this.fetchPaged();
      }
    }
  }
}

export default paginationMixin;
