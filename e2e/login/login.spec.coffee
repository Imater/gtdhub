screenshot = require("../screenshot.po")

#e2e test......
"use strict"
describe "Login View", ->
  page = undefined
  beforeEach ->
    browser.get "/login"
    page = require("./login.po.coffee")

  it "should have test user logined", ->
    expect(page.h1El.getText()).toBe "Login"
    page.loginInput.clear().sendKeys 'test@test.com'
    page.passwordInput.clear().sendKeys 'test'
    page.loginBtn.click()
    mainPage = require("../main/main.po.coffee")
    expect( mainPage.helloLoginned.getText() ).toBe 'Hello Test User'
    mainPage.logoutBtn.click()
    expect( mainPage.helloLoginned.getText() ).toBe ''

  it "should have admin user logined", ->
    expect(page.h1El.getText()).toBe "Login"
    page.loginInput.clear().sendKeys 'admin@admin.com'
    page.passwordInput.clear().sendKeys 'admin'
    page.loginBtn.click()
    mainPage = require("../main/main.po.coffee")
    expect( mainPage.helloLoginned.getText() ).toBe 'Hello Admin'
    mainPage.logoutBtn.click()
    expect( mainPage.helloLoginned.getText() ).toBe ''

