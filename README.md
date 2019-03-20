### JsonApi Filtering

This is an example of a module that allows to filtering collections from the client side

Supported operators: is, contains, between, in, not_in, begin, end

Supported logic: AND, OR

#### Example

##### Request

```/items
?filter[0][field]=category.sections.id
&filter[0][value][]=1
&filter[0][value][]=5
&filter[0][operator]=between
&filter[1][field]=tags.id
&filter[1][value]=1
&filter[1][operator]=is
&filter_logic=or
&page[limit]=1
&page[offset]=0
&sort=author,-id
```

##### Query
```mysql
SELECT
       COUNT(DISTINCT `items`.`id`)
FROM `items`
  INNER JOIN `categories` ON `categories`.`id` = `items`.`category_id`
  INNER JOIN `sections` ON `sections`.`id` = `categories`.`section_id`
  INNER JOIN `items_tags` ON `items_tags`.`item_id` = `items`.`id`
  INNER JOIN `tags` ON `tags`.`id` = `items_tags`.`tag_id`
WHERE `section`.`id` BETWEEN 1 AND 5 OR `tags`.`id` = 1
```

##### Response
```
{
  "data": [
    {
      "id": "1",
      "type": "item",
      "attributes": {
        "id": 1,
        "name": "The first item",
        "disabled": false,
        "deleted": false,
        "categoryId": 1,
        "author": "John Smith"
        "image": {
          "thumb": "/images/items/1/thumb/item_1.jpeg",
          "original": "/images/items/1/original/item_1.jpeg"
        },
      },
      "relationships": {
        "category": {
          "data": {
            "id": "1",
            "type": "category"
          }
        },
        "tags": {
          "data": [
            {
              "id": "1",
              "type": "tag"
            },
            {
              "id": "2",
              "type": "tag"
            }
          ]
        }
      }
    },
    ...
  ],
  "included": [
    {
      "id": "1",
      "type": "category",
      "attributes": {
        "id": 1,
        "name": "The first category"
      },
      "relationships": {}
    }
  ],
  "meta": {
    "sorts": {
      "sorts": [
        {
          "field": "author",
          "direction": "asc"
        },
        {
          "field": "id",
          "direction": "desc"
        }
      ]
    },
    "pagination": {
      "limit": 1,
      "offset": 0,
      "count": 22
    },
    "filter": {
      "logic": "or",
      "rules": [
        {
          "field": "id",
          "table": "sections",
          "path": "category.sections",
          "value": [
            "1",
            "5"
          ],
          "operator": "between"
        },
        {
          "field": "id",
          "table": "tags",
          "path": "tags",
          "value": "1",
          "operator": "is"
        }
      ]
    }
  }
}
```
