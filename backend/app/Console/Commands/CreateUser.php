<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class CreateUser extends Command
{
    protected $signature = 'app:create-user
                            {role : visitor|editor|admin}
                            {email : Email dang nhap}
                            {name : Ten hien thi}';

    protected $description = 'Tao tai khoan kiem thu cho DT-16 Virtual Museum 360';

    public function handle(): int
    {
        $role = Str::lower(trim((string) $this->argument('role')));
        $email = Str::lower(trim((string) $this->argument('email')));
        $name = trim((string) $this->argument('name'));

        $allowedRoles = [
            'visitor',
            'editor',
            'admin',
        ];

        if (! in_array($role, $allowedRoles, true)) {
            $this->error('Role khong hop le. Chi chap nhan: visitor, editor, admin.');

            return self::FAILURE;
        }

        if (! filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $this->error('Email khong hop le.');

            return self::FAILURE;
        }

        if ($name === '') {
            $this->error('Name khong duoc rong.');

            return self::FAILURE;
        }

        $exists = DB::table('users')
            ->where('email', $email)
            ->exists();

        if ($exists) {
            $this->error('Email da ton tai trong users.');

            return self::FAILURE;
        }

        $password = $this->secret('Nhap mat khau kiem thu');

        if ($password === false || $password === '') {
            $this->error('Mat khau khong duoc rong.');

            return self::FAILURE;
        }

        if (mb_strlen($password) < 8) {
            $this->error('Mat khau phai co it nhat 8 ky tu.');

            return self::FAILURE;
        }

        DB::table('users')->insert([
            'name' => $name,
            'email' => $email,
            'password_hash' => Hash::make($password),
            'role' => $role,
            'is_active' => 1,
        ]);

        $this->info('Tao tai khoan thanh cong.');
        $this->line("Email: {$email}");
        $this->line("Role: {$role}");

        return self::SUCCESS;
    }
}