test("API_HOST env var not set", () => {
  expect(process.env.API_HOST).toEqual(undefined);
});

test("PORT env var not set", () => {
  expect(process.env.PORT).toEqual(undefined);
});
