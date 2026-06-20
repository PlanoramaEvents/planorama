import dateTimeMixin from '@/components/date_time.mixin'

export const tableCellFormatterMixin = {
  mixins: [
    dateTimeMixin,
  ],
  props: {
    formatters : { 
      default: null
    }
  },
  methods: {
    format_cell(column, data) {
      let res = null;
      if (column.key != 'selected') {
        if (this.formatters && this.formatters[column.key]) {
          res = this.formatters[column.key](data)
        }
        if (!res) {
          if (typeof v === 'boolean') {
            res = data[column.key] ? 'Yes' : 'No'
          } else if (Array.isArray(data[column.key])) {
            res = data[column.key].join(", ")
          } else {
            if (this.isDateTime(data[column.key])) {
              res = this.formatLocaleDate(data[column.key])
            } else if (data[column.key] && typeof data[column.key].email !== 'undefined') {
              res = data[column.key].email
            } else {
              res = data[column.key]
            }                  
          }
        }
      }

      return res;
    }
  }
}

export default tableCellFormatterMixin;
