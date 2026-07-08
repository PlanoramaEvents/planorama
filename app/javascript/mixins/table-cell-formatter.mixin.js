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
          // console.debug("******* RES ", column.key, data)
          if (typeof data[column.key] === 'undefined') {
            const keys = column.key.split(".")
            if (keys.length == 2) {
              // console.debug("**** keys ", keys)
              let obj = data[keys[0]]
              if (obj) {
                res = obj[keys[1]]
              }
            }
          } else if (typeof data[column.key] === 'boolean') {
            res = data[column.key] ? 'Yes' : 'No'
          } else if (Array.isArray(data[column.key])) {
            res = data[column.key].join(", ")
          } else if (data[column.key] != null) {
            // ISO dates are long strings ending with "Z"
            if (data[column.key].length > 20 && data[column.key].endsWith("Z") && this.isDateTime(data[column.key])) {
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
