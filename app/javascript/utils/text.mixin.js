export const textMixin = {
  methods: {
    na_if_empty(value) {
      if (value === undefined) return 'Restricted'
      if (value === true) return "Yes"
      if (value === false) return "No"
      if (value === null || value.trim().length == 0) return 'Not Specified'
      return value
    },
    capitalize(value) {
      if (value && value.length > 0) {
        return value.replace(/\w\S*/g, (w) => (w.replace(/^\w/, (c) => c.toUpperCase())))
      }
      return value
    }
  }
}
