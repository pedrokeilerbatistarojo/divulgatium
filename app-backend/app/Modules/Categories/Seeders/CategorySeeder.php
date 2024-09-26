<?php

namespace App\Modules\Categories\Seeders;

use Illuminate\Database\Seeder;
use App\Modules\Categories\Models\Category;

class CategorySeeder extends Seeder
{
    private array $categories = [
        "Art",
        "Astronomy and Astrophysics",
        "Cinema",
        "Crimes and Mysteries",
        "Documentaries and Biography",
        "Economics and Finance",
        "Education",
        "Environment and Agroecology",
        "Gastronomy",
        "History and Literature",
        "Journalism",
        "Law and Society",
        "Medicine and Biology",
        "Music and Sports",
        "Neuroscience",
        "Philosophy and Free Thinkers",
        "Psychology and Psychiatry",
        "Sciences",
        "Technology and Innovation",
        "Travel and Cultures",
    ];

    private array $subcategories = [
        "Art" => ["Architecture", "Graphic", "Design"],
        "Sciences" => ["Physics", "Chemistry", "Mathematics"]
    ];

    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        foreach ($this->categories as $category){
            $categoryObject = Category::create(["name" => $category]);

            foreach ($this->subcategories as $parent => $subcategoryList){
                if  ($parent == $category){
                    foreach ($subcategoryList as $subcategory){
                        Category::create(
                            [
                                "name" => $subcategory,
                                "category_id" => $categoryObject->id
                            ]
                        );
                    }
                }
            }
        }
    }
}
