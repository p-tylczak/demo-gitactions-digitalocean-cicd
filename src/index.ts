import { Hono } from 'hono'

const app = new Hono()

app.get('/', (c) => {
  return c.text('Hello Hono, Reload!')
})

export default {
  port: 3001,
  fetch: app.fetch,
}
