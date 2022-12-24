package main

import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers

class MainSpec extends AnyFlatSpec with Matchers {
  "The Hello object" should "say hello" in {
    Main.foobar shouldEqual 99
  }
}
