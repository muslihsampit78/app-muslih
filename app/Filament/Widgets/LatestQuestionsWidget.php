<?php

namespace App\Filament\Widgets;

use App\Enums\QuestionStatus;
use App\Filament\Resources\Questions\QuestionResource;
use App\Models\Question;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget;
use Illuminate\Database\Eloquent\Builder;

class LatestQuestionsWidget extends TableWidget
{
    protected static ?int $sort = 2;

    protected static ?string $heading = 'Pertanyaan Terbaru dari Masyarakat';

    protected int|string|array $columnSpan = 'full';

    public function table(Table $table): Table
    {
        return $table
            ->query(fn (): Builder => Question::query()->with('topic')->latest()->limit(5))
            ->columns([
                TextColumn::make('created_at')
                    ->label('Waktu Masuk')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
                TextColumn::make('name')
                    ->label('Penanya')
                    ->description(fn ($record): string => $record->email),
                TextColumn::make('topic.name')
                    ->label('Topik')
                    ->badge()
                    ->color('info'),
                TextColumn::make('subject')
                    ->label('Subjek')
                    ->limit(40),
                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->formatStateUsing(fn ($state) => $state instanceof QuestionStatus ? $state->label() : QuestionStatus::tryFrom($state)?->label() ?? $state)
                    ->color(fn ($state) => match ($state instanceof QuestionStatus ? $state : QuestionStatus::tryFrom($state)) {
                        QuestionStatus::Answered => 'success',
                        QuestionStatus::Rejected => 'danger',
                        default => 'warning',
                    }),
            ])
            ->recordUrl(fn (Question $record): string => QuestionResource::getUrl('edit', ['record' => $record]))
            ->paginated(false);
    }
}
