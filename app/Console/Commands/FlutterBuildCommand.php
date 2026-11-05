<?php

namespace App\Console\Commands;

use Illuminate\Console\Attributes\Description;
use Illuminate\Console\Attributes\Signature;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Symfony\Component\Process\Process;

#[Signature('flutter:build {--base-href=/ : Base href for Flutter Web}')]
#[Description('Build Flutter Web frontend and deploy assets to Laravel public directory')]
class FlutterBuildCommand extends Command
{
    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $frontendPath = base_path('frontend');

        if (! File::isDirectory($frontendPath)) {
            $this->error("Directory {$frontendPath} does not exist.");

            return self::FAILURE;
        }

        $baseHref = (string) $this->option('base-href');
        $this->info("Building Flutter Web frontend (base-href: {$baseHref})...");

        $flutterBinary = windows_os() ? 'flutter.bat' : 'flutter';
        $process = new Process([$flutterBinary, 'build', 'web', '--base-href', $baseHref], $frontendPath, [
            'PATH' => getenv('PATH') ?: 'C:\develop\flutter\bin;C:\laragon\bin\git\cmd',
        ]);
        $process->setTimeout(600);

        $process->run(function ($type, $buffer): void {
            $this->output->write($buffer);
        });

        if (! $process->isSuccessful()) {
            $this->error('Flutter build failed.');

            return self::FAILURE;
        }

        $buildWebPath = base_path('frontend/build/web');
        $publicPath = public_path();

        $this->info('Copying built files to Laravel public directory...');
        File::copyDirectory($buildWebPath, $publicPath);

        $this->info('Flutter Web frontend deployed successfully to public directory!');
        $this->line('Visit: <comment>'.url('/').'</comment>');

        return self::SUCCESS;
    }
}
