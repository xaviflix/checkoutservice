# The "checkoutservice"

## Summary
The checkoutservice is created receiving a reference to the system storage, and for each scan operation (where the product
code is received as input parameter) is able to verify the item and add it to the basket. Once all items are in the basket, 
it calculates the total amount, taking into account the number of items and the applicable price rules.

## Product notes
- It is not defined, but I take the assumption that code product is unique for each product
- It is not defined, but I take the assumption that a product can only be registered to one price rule at the same time
- I added a requirement (ooops!) in the price rule creation, when this rule implies a % discount on the product price, 
not allowing discounts above a defined threshold.

## Technical notes
- **Private methods naming convention**: Let's start with the hard one fist! I know the naming convention is not the Ruby 
way, actually it is the _pythionic_ way; but I would like to expose it because with our current team agreed on the need 
of using this private methods' notation to make code easy to read, maybe it is not evident on new/pretty code, but it gave 
us good results on legacy (not so pretty) code with long classes/modules.
- **Positional vs Named parameters**: To be honest, this still generates doubts to our team (and to myself). Everyone is 
100% agree that using always positional parameters is dangerous and not a good practice, but moving 100% to named parameters makes 
the code so boilerplate sometimes ... These are the rules I followed:
  - Methods with 1 or 2 parameters should use positional parameters (except for models creation)
  - Methods with >2 parameters should use named parameters
  - Parameters with default values should be always named parameters
  - Merging positional and named parameters is allowed
- **Float vs Money**: I'm aware that the amounts in the code (prices) are set only as, let's say, _money.value_, and I did 
not add the _money.currency_ part. This could be solved in all the models with currency amounts (_Product.price_ for example) 
by moving to the Money class for example. To be honest, I do not think this change will drive a significant change in the 
exercise purpose and on the other side, it will complicate a bit more the code and the test cases to ensure an updated 
price for a Product due to a discount must be defined in the same currency, and that all products in the basket must be in the same currency 
to be able to calculate the total amount ...
- **Hardcoded values in test**: The tests are using some hardcoded constants, rather than using the _MODEL::CONSTANT_ value, 
to ensure that some tests will fail if someone change the definition of an enumeration. At least we want to trigger 
a deeper review to ensure there are no side effects (mainly with old data in the DB).
- **PriceRule and PriceRuleExecutor relationship**: In this exercise I propose a more classical approach where the 
PriceRuleExecutor, based on the PriceRule type, selects the logic to be run. Another option, would be for the PriceRule 
to store the name of the PriceRuleExecutor module name and the input parameters and then, have a more simple PriceRuleExecutor 
where we load the desired module at runtime with the parameters and execute it. This proposal, despite being elegant, is 
somehow more obscure and cumbersome, as implies DB migrations for old data in case of renaming some XxxRuleExecutor, 
which is annoying.
- **Static typing vs Dynamic typing**: I know Ruby 3 introduces static typing, but I did not use it here. In my current 
team, when working with Python we moved to static typing, and it has its advantages (despite having bad parameters name 
the code is clear), but also disadvantages (many times the code is extremely verbose) ... Open discussion here!

## Tests
- To run all tests execute ``rake all_test``
- To run only the unit tests execute ``rake unit_test``
- To run only the integration tests execute ``rake integration_test``
- To run only a single test execute ``rake single_test TEST="test/unit_tests/models/product_test.rb"``
