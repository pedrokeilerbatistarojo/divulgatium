<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id();
            $table->string('name', 255)->unique();
            $table->string('username', 255)->unique();
            $table->string('password', 255);
            $table->string('email', 255)->nullable()->unique();
            $table->string('phone', 255)->nullable()->unique();
            $table->boolean('active')->nullable();
            $table->dateTime('last_login')->nullable();

            // N .. 1
            $table->foreignId('role_id')
                ->nullable()
                ->constrained('roles')
                ->onDelete('cascade');

            $table->foreignId('category_id')
                ->nullable()
                ->constrained('categories');

            $table->foreignId('country_id')
                ->nullable()
                ->constrained('countries');


            $table->index(['username', 'password'], 'user_password_index');
            $table->timestamps();

            //Optimistic Locking
            $table->integer('lock_version')
                ->unsigned()
                ->nullable();
        });

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->index();
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('users');
        Schema::dropIfExists('password_reset_tokens');
        Schema::dropIfExists('sessions');
    }
};
